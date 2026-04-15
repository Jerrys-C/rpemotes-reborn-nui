---@type table<string, EmoteData>
EmoteData = {}

---@type table<string, SharedEmoteData>
SharedEmoteData = {}

---@type table<string, ExpressionData>
ExpressionData = {}

---@type table<string, WalkData>
WalkData = {}

local isNuiMenuOpen = false

--- Send toast notifications to NUI; fall back to SimpleNotify when the menu is not open
---@param msg string
---@param toastType? string "success"|"error"|"warning"|"info"
---@param duration? number milliseconds, default 3500
function ShowToast(msg, toastType, duration)
    local clean = string.gsub(tostring(msg), "~%a+~", "")
    if isNuiMenuOpen then
        SendNUIMessage({
            action    = "showToast",
            msg       = clean,
            toastType = toastType or "info",
            duration  = duration,
        })
    else
        SimpleNotify(msg)
    end
end
local isWaitingForPed = false
local cachedPayload = nil
local currentZoomState = false

---@type table<string, {name: string, emoteType: EmoteType}[]>
local categoryToEmotes = {}

-- LastEmote is a global defined in Emote.lua; we read/write it for preview ped state

-- ─── Utility functions (preserved from original) ───

local function canPlayerEmote()
    if not LocalPlayer.state.canEmote and GetConvar("onesync", "on") == "on" then
        return false, Translate('emotesblocked')
    end
    local ped = PlayerPedId()
    if IsEntityDead(ped) then
        return false, Translate('dead')
    end
    if (IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped)) and not Config.AllowInWater then
        return false, Translate('swimming')
    end
    return true
end

local function hasClonedPed()
    return ClonedPed and DoesEntityExist(ClonedPed)
end

local function getPreviewZoomForEmoteType(emoteType)
    return emoteType == EmoteType.EXPRESSIONS
end

local function isEmoteTypePreviewable(emoteType)
    return emoteType == EmoteType.DANCES
        or emoteType == EmoteType.EMOTES
        or emoteType == EmoteType.EXPRESSIONS
        or emoteType == EmoteType.PROP_EMOTES
        or emoteType == EmoteType.ANIMAL_EMOTES
        or emoteType == EmoteType.SHARED
end

local function isEmoteTypePlayable(emoteType)
    return emoteType == EmoteType.DANCES
        or emoteType == EmoteType.ANIMAL_EMOTES
        or emoteType == EmoteType.PROP_EMOTES
        or emoteType == EmoteType.EMOTES
end

local function matchesSearchTerm(emoteName, emoteData, searchTerm)
    local lowerSearch = string.lower(searchTerm)
    return string.find(string.lower(emoteName), lowerSearch)
        or (emoteData.label
            and string.find(string.lower(emoteData.label), lowerSearch))
end

---@param emoteName string
---@param emoteType EmoteType
---@return EmoteData|SharedEmoteData|ExpressionData|WalkData|nil
local function getEmoteData(emoteName, emoteType)
    if emoteType == EmoteType.SHARED then
        return SharedEmoteData[emoteName]
    elseif emoteType == EmoteType.EXPRESSIONS then
        return ExpressionData[emoteName]
    elseif emoteType == EmoteType.WALKS then
        return WalkData[emoteName]
    else
        return EmoteData[emoteName]
    end
end

---@param emoteItem string|{name: string, emoteType: EmoteType}
---@return string
local function getEmoteLabel(emoteItem)
    local emoteName = type(emoteItem) == "table" and emoteItem.name or emoteItem
    local emoteType = type(emoteItem) == "table" and emoteItem.emoteType or nil

    local data = getEmoteData(emoteName, emoteType)
    return data and data.label or emoteName
end

---@param emotes string[] | {name: string, emoteType: EmoteType}[]
local function sortEmotesByLabel(emotes)
    table.sort(emotes, function(a, b)
        local labelA = getEmoteLabel(a)
        local labelB = getEmoteLabel(b)
        return string.lower(labelA) < string.lower(labelB)
    end)
end

--- Expands EmoteTypes in CustomCategories to actual emote names
---@return table<string, {name: string, emoteType: EmoteType}[]>
local function expandCustomCategories()
    local expanded = {}

    for categoryName, emoteTypeMap in pairs(Config.CustomCategories) do
        expanded[categoryName] = {}

        for emoteType, emoteNames in pairs(emoteTypeMap) do
            if #emoteNames == 0 then
                if RP and RP[emoteType] then
                    for emoteName in pairs(RP[emoteType]) do
                        expanded[categoryName][#expanded[categoryName]+1] = {
                            name = emoteName,
                            emoteType = emoteType
                        }
                    end
                end
            else
                for _, emoteName in ipairs(emoteNames) do
                    if RP and RP[emoteType] and RP[emoteType][emoteName] then
                        expanded[categoryName][#expanded[categoryName]+1] = {
                            name = emoteName,
                            emoteType = emoteType
                        }
                    end
                end
            end
        end
    end

    return expanded
end

local function shouldShowEmojiMenu()
    if not Config.EmojiMenuEnabled then return false end
    if not Config.EmojiMenuAnimalsOnly then return true end
    return not IsPedHuman(PlayerPedId())
end

function SendSharedEmoteRequest(emoteName)
    local target, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("rpemotes:server:requestEmote", GetPlayerServerId(target), emoteName)
        ShowToast(Translate('sentrequestto') .. GetPlayerName(target), 'success')
    else
        ShowToast(Translate('nobodyclose'), 'warning')
    end
end

--- Simplified emote selection handler for NUI
--- NUI sends explicit intent (play, place, group, keybind) via separate callbacks
local function handleEmoteSelection(emoteName, emoteType, textureVariation)
    local emote = getEmoteData(emoteName, emoteType)
    if not emote then return end

    if not HasEmotePermission(emoteName, emoteType) then
        ShowToast("You don't have permission to use this emote", 'error')
        return
    end

    if emote.emoteType == EmoteType.SHARED then
        SendSharedEmoteRequest(emoteName)
    elseif isEmoteTypePlayable(emote.emoteType) then
        EmoteMenuStart(emoteName, textureVariation, emoteType)
    end
end

local function hidePreview()
    LastEmote = {}
    currentZoomState = false

    if hasClonedPed() then
        ClosePedMenu()
    end
end

-- ─── Data conversion (preserved from original) ───

---@param emoteName string
---@param emote EmoteData
local function convertToEmoteData(emoteName, emote)
    local arraySize = 0
    for i = 1, 4 do
        if emote[i] then
            arraySize += 1
        end
    end

    if arraySize == 1 then
        emote.anim = emote[1]
        emote.label = emoteName
    elseif arraySize == 2 then
        emote.anim = emote[1]
        emote.label = emote[2]
    elseif arraySize >= 3 then
        local type = emote[1]
        if type == ScenarioType.MALE or type == ScenarioType.SCENARIO or type == ScenarioType.OBJECT then
            emote.scenario = emote[2]
            emote.scenarioType = type
        else
            emote.dict = emote[1]
            emote.anim = emote[2]
            emote.secondPlayersAnim = emote[4]
        end
        emote.label = emote[3]
    end

    -- Apply emote label translation
    local translated = TranslateEmoteLabel(emoteName)
    if translated then emote.label = translated end

    local animOptions = emote.AnimationOptions
    if animOptions and not animOptions.onFootFlag then
        if animOptions.EmoteMoving then
            animOptions.onFootFlag = AnimFlag.MOVING
        elseif animOptions.EmoteLoop then
            animOptions.onFootFlag = AnimFlag.LOOP
        elseif animOptions.EmoteStuck then
            animOptions.onFootFlag = AnimFlag.STUCK
        end
    end

    if animOptions and animOptions.Attachto then
        animOptions.pos = animOptions.pos
            or vector3(animOptions.xPos or 0.0, animOptions.yPos or 0.0, animOptions.zPos or 0.0)
        animOptions.rot = animOptions.rot
            or vector3(animOptions.xRot or 0.0, animOptions.yRot or 0.0, animOptions.zRot or 0.0)
    end

    if animOptions and not animOptions.vehicleRequirement then
        if animOptions.NotInVehicle then
            animOptions.vehicleRequirement = VehicleRequirement.NOT_ALLOWED
        elseif animOptions.onlyInVehicle then
            animOptions.vehicleRequirement = VehicleRequirement.REQUIRED
        end
    end

    if animOptions and (animOptions.SyncOffsetSide
        or animOptions.SyncOffsetFront
        or animOptions.SyncOffsetHeight
        or animOptions.SyncOffsetHeading)
    then
        animOptions.syncOffset = vector4(
            animOptions.SyncOffsetSide or 0.0,
            animOptions.SyncOffsetFront or 1.0,
            animOptions.SyncOffsetHeight or 0.0,
            animOptions.SyncOffsetHeading or 180.0)
    end
end

local function convertRP()
    local newRP = {}
    assert(RP ~= nil)
    for emoteType, content in pairs(RP) do
        for emoteName, emoteData in pairs(content) do
            if Config.AdultEmotesDisabled and emoteData.AdultAnimation then
                goto continue
            end

            if Config.AbusableEmotesDisabled and emoteData.abusable then
                goto continue
            end

            if emoteType == EmoteType.EXPRESSIONS then
                if ExpressionData[emoteName] then
                    print(string.format("WARNING - Duplicate expression name found: %s", emoteName))
                end
                emoteData.anim = emoteData[1]
                emoteData.label = emoteData[2] or emoteName
                local translatedExpr = TranslateEmoteLabel(emoteName)
                if translatedExpr then emoteData.label = translatedExpr end
                ExpressionData[emoteName] = emoteData
            elseif emoteType == EmoteType.WALKS then
                if WalkData[emoteName] then
                    print(string.format("WARNING - Duplicate walk name found: %s", emoteName))
                end
                emoteData.anim = emoteData[1]
                emoteData.label = emoteData[2] or emoteName
                local translatedWalk = TranslateEmoteLabel(emoteName)
                if translatedWalk then emoteData.label = translatedWalk end
                WalkData[emoteName] = emoteData
            elseif emoteType == EmoteType.SHARED then
                if SharedEmoteData[emoteName] then
                    print(string.format("WARNING - Duplicate shared emote name found: %s", emoteName))
                end

                if type(emoteData) == "table" then
                    local sharedEmote = {}
                    for k, v in pairs(emoteData) do
                        sharedEmote[k] = v
                    end
                    sharedEmote.emoteType = emoteType
                    convertToEmoteData(emoteName, sharedEmote)
                    SharedEmoteData[emoteName] = sharedEmote
                end
            else
                if newRP[emoteName] then
                    print(string.format(
                        "WARNING - Duplicate emote name found: %s in %s and %s",
                        emoteName, emoteType, newRP[emoteName].emoteType
                    ))
                end

                if type(emoteData) == "table" then
                    newRP[emoteName] = {}
                    for k, v in pairs(emoteData) do
                        newRP[emoteName][k] = v
                    end
                else
                    newRP[emoteName] = {emoteData}
                end

                newRP[emoteName].emoteType = emoteType
                convertToEmoteData(emoteName, newRP[emoteName])
            end
            ::continue::
        end
    end
    EmoteData = newRP

    -- Expand custom categories after EmoteData is populated
    categoryToEmotes = expandCustomCategories()

    RP = nil
    CONVERTED = true
end

-- ─── NUI Payload Builder ───

--- Build emote items for a given data source, filtered by model compatibility and config
---@param emoteDataSource table<string, EmoteData|SharedEmoteData>
---@param emoteType EmoteType
---@param filterTypes? EmoteType[] if provided, only include emotes whose emoteType is in this list
---@return table[]
local function buildEmoteItems(emoteDataSource, emoteType, filterTypes)
    local items = {}
    for emoteName, data in pairs(emoteDataSource) do
        -- Apply emoteType filter if specified
        if filterTypes then
            local found = false
            for _, ft in ipairs(filterTypes) do
                if data.emoteType == ft then found = true break end
            end
            if not found then goto continue end
        end

        -- Check config flags
        if data.emoteType == EmoteType.ANIMAL_EMOTES and not Config.AnimalEmotesEnabled then
            goto continue
        end
        if data.emoteType == EmoteType.SHARED and not Config.SharedEmotesEnabled then
            goto continue
        end

        -- Check model compatibility
        if CachedPlayerModel and not IsModelCompatible(CachedPlayerModel, emoteName) then
            goto continue
        end

        local item = {
            name = emoteName,
            label = data.label or emoteName,
            emoteType = data.emoteType or emoteType,
            hasPermission = HasEmotePermission(emoteName, data.emoteType or emoteType),
        }

        -- Include prop texture variations if present
        if data.AnimationOptions and data.AnimationOptions.PropTextureVariations then
            item.propVariations = data.AnimationOptions.PropTextureVariations
        end

        items[#items+1] = item
        ::continue::
    end

    -- Sort by label
    table.sort(items, function(a, b)
        return string.lower(a.label) < string.lower(b.label)
    end)

    return items
end

--- Build the categories payload for the NUI menu
---@return table<string, table[]>
local function buildCategories()
    local categories = {}

    -- Custom categories (dances, props, shared, user-defined)
    for categoryName, emoteList in pairs(categoryToEmotes) do
        local items = {}
        sortEmotesByLabel(emoteList)
        for _, emoteInfo in ipairs(emoteList) do
            local data = getEmoteData(emoteInfo.name, emoteInfo.emoteType)
            if data then
                -- Check config flags
                if data.emoteType == EmoteType.ANIMAL_EMOTES and not Config.AnimalEmotesEnabled then
                    goto continue
                end
                if data.emoteType == EmoteType.SHARED and not Config.SharedEmotesEnabled then
                    goto continue
                end
                -- Check model compatibility
                if CachedPlayerModel and not IsModelCompatible(CachedPlayerModel, emoteInfo.name) then
                    goto continue
                end

                local item = {
                    name = emoteInfo.name,
                    label = data.label or emoteInfo.name,
                    emoteType = data.emoteType or emoteInfo.emoteType,
                    hasPermission = HasEmotePermission(emoteInfo.name, emoteInfo.emoteType),
                }
                if data.AnimationOptions and data.AnimationOptions.PropTextureVariations then
                    item.propVariations = data.AnimationOptions.PropTextureVariations
                end
                items[#items+1] = item
                ::continue::
            end
        end
        categories[categoryName] = items
    end

    -- Main emotes category (regular emotes + animal emotes)
    local mainEmotes = {}
    for emoteName, data in pairs(EmoteData) do
        local isRegularEmote = data.emoteType == EmoteType.EMOTES
        local isAnimalEmote = Config.AnimalEmotesEnabled and data.emoteType == EmoteType.ANIMAL_EMOTES
        if isRegularEmote or isAnimalEmote then
            if not CachedPlayerModel or IsModelCompatible(CachedPlayerModel, emoteName) then
                local item = {
                    name = emoteName,
                    label = data.label or emoteName,
                    emoteType = data.emoteType,
                    hasPermission = HasEmotePermission(emoteName, data.emoteType),
                }
                if data.AnimationOptions and data.AnimationOptions.PropTextureVariations then
                    item.propVariations = data.AnimationOptions.PropTextureVariations
                end
                mainEmotes[#mainEmotes+1] = item
            end
        end
    end
    table.sort(mainEmotes, function(a, b)
        return string.lower(a.label) < string.lower(b.label)
    end)
    categories[Translate('emotes')] = mainEmotes

    return categories
end

--- Build favorites payload
---@return table
local function buildFavorites()
    local favoriteEmotes = GetFavoriteEmotes()
    local result = {}
    for id, data in pairs(favoriteEmotes) do
        result[id] = {
            name = data.name,
            label = data.label or data.name,
            emoteType = data.emoteType,
        }
    end
    return result
end

--- Build keybind data
---@return table[]
local function buildKeybindData()
    local keybinds = {}
    for id = 1, #Config.KeybindKeys do
        local emoteData = GetResourceKvpString(string.format('%s_bind_%s', Config.keybindKVP, id))
        local parsed = nil
        if emoteData and emoteData ~= "" then
            parsed = json.decode(emoteData)
        end
        keybinds[#keybinds+1] = {
            slot = id,
            label = parsed and parsed.label or nil,
            emoteName = parsed and parsed.emoteName or nil,
            emoteType = parsed and parsed.emoteType or nil,
            keyLabel = GetKeyForCommand("emoteSelect"..id),
        }
    end
    return keybinds
end

--- Build walks data
---@return table[]
local function buildWalkData()
    local walks = {}
    for name, data in pairs(WalkData) do
        walks[#walks+1] = {
            name = name,
            label = data.label or name,
            hasPermission = HasEmotePermission(name, EmoteType.WALKS),
        }
    end
    table.sort(walks, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
    return walks
end

--- Build expressions data
---@return table[]
local function buildExpressionData()
    local expressions = {}
    for name, data in pairs(ExpressionData) do
        expressions[#expressions+1] = {
            name = name,
            label = data.label or name,
            hasPermission = HasEmotePermission(name, EmoteType.EXPRESSIONS),
        }
    end
    table.sort(expressions, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
    return expressions
end

--- Build emoji data
---@return table[]
local function buildEmojiData()
    if not shouldShowEmojiMenu() then return {} end
    local emojis = {}
    for key, emoji in pairs(EmojiData) do
        emojis[#emojis+1] = {
            name = key,
            label = emoji .. " " .. key:gsub("_", " "),
        }
    end
    table.sort(emojis, function(a, b) return a.name < b.name end)
    return emojis
end

--- Get relevant config for NUI
---@return table
local function getRelevantConfig()
    return {
        searchEnabled = Config.Search,
        keybindingEnabled = Config.Keybinding,
        commandTooltipEnabled = Config.CommandTooltip ~= false,
        placementEnabled = Config.PlacementEnabled,
        sharedEmotesEnabled = Config.SharedEmotesEnabled,
        animalEmotesEnabled = Config.AnimalEmotesEnabled,
        expressionsEnabled = Config.ExpressionsEnabled,
        walkingStylesEnabled = Config.WalkingStylesEnabled,
        emojiMenuEnabled = shouldShowEmojiMenu(),
    }
end

--- Raw locale lookup (no string.format) – safe for strings with %s placeholders
---@param key string
---@return string
local function TranslateRaw(key)
    local lang = Locales[Config.MenuLanguage]
    if lang and lang[key] then return lang[key] end
    if Config.MenuLanguage ~= "en" and Locales["en"] and Locales["en"][key] then
        return Locales["en"][key]
    end
    return key
end

--- Get translations for NUI
---@return table
local function getTranslations()
    local keys = {
        'emotes', 'danceemotes', 'animalemotes', 'propemotes', 'shareemotes',
        'cancelemote', 'walkingstyles', 'moods', 'favorites', 'keybinds', 'emojis',
        'searchemotes', 'searchnoresult', 'normalreset', 'resetdef',
        'btn_select', 'btn_back', 'btn_place',
        'btn_set_favorite', 'btn_remove_favorite', 'btn_setkeybind', 'btn_delkeybind',
        'btn_groupselect', 'cancelemoteinfo', 'favoritesinfo',
        'addedtofavorites', 'removedfromfavorites', 'btn_rightclick',
        'newlist', 'editlist', 'deletelist', 'createlist', 'savelist',
        'listname', 'maxlists', 'emptylist', 'addedtolist', 'removedfromlist',
        'confirmdelete', 'cannotundo', 'copycommand', 'copiedcommand',
    }
    local t = {}
    for _, key in ipairs(keys) do
        t[key] = TranslateRaw(key)
    end
    return t
end

--- Build the full menu payload for NUI
---@return table
--- Reverse-lookup expression name from stored anim string
local function getActiveExpressionName()
    local anim = GetResourceKvpString("expression")
    if not anim or anim == "" then return nil end
    for name, data in pairs(ExpressionData) do
        if type(data) == "table" and data.anim == anim then return name end
    end
    return nil
end

--- Build active walk/expression status for NUI
local function buildActiveStatus()
    local walkName = GetResourceKvpString("walkstyle")
    local exprName = getActiveExpressionName()
    return {
        activeWalk = walkName or "",
        activeWalkLabel = walkName and (WalkData[walkName] and WalkData[walkName].label or walkName) or "",
        activeExpression = exprName or "",
        activeExpressionLabel = exprName and (ExpressionData[exprName] and ExpressionData[exprName].label or exprName) or "",
    }
end

local function sendActiveStatus()
    local status = buildActiveStatus()
    status.action = "updateStatus"
    SendNUIMessage(status)
end

local function buildMenuPayload()
    local payload = {
        action = "openMenu",
        categories = buildCategories(),
        keybinds = buildKeybindData(),
        walks = Config.WalkingStylesEnabled and buildWalkData() or {},
        expressions = Config.ExpressionsEnabled and buildExpressionData() or {},
        emojis = buildEmojiData(),
        config = getRelevantConfig(),
        translations = getTranslations(),
    }
    local status = buildActiveStatus()
    for k, v in pairs(status) do payload[k] = v end
    return payload
end

-- ─── Menu Open/Close ───

function CloseNUIMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeMenu" })
    isNuiMenuOpen = false
    hidePreview()
end

local lastMenuOpenAttempt = 0

--- Input thread — disable weapon/camera/frontend controls while NUI is open
local function startMenuInputThread()
    CreateThread(function()
        while isNuiMenuOpen do
            Wait(0)

            -- Disable mouse look so cursor moves freely without rotating camera
            DisableControlAction(0, 1, true)   -- LOOK_LR
            DisableControlAction(0, 2, true)   -- LOOK_UD
            DisableControlAction(0, 106, true) -- VEH_MOUSE_CONTROL_OVERRIDE

            -- Disable weapon actions so clicking NUI doesn't fire
            DisableControlAction(0, 24, true)  -- ATTACK
            DisableControlAction(0, 25, true)  -- AIM
            DisableControlAction(0, 257, true) -- ATTACK2

            -- Disable frontend controls to prevent game-side actions
            DisableControlAction(0, 172, true) -- UP
            DisableControlAction(0, 173, true) -- DOWN
            DisableControlAction(0, 174, true) -- LEFT
            DisableControlAction(0, 175, true) -- RIGHT
            DisableControlAction(0, 176, true) -- SELECT (Enter)
            DisableControlAction(0, 177, true) -- CANCEL (Backspace)
            DisableControlAction(0, 200, true) -- PAUSE (Esc)
        end
    end)
end

function OpenEmoteMenu()
    local now = GetGameTimer()
    if now - lastMenuOpenAttempt < 200 then return end
    lastMenuOpenAttempt = now

    -- Toggle off if already open
    if isNuiMenuOpen then
        CloseNUIMenu()
        return
    end

    local canEmote, errorMsg = canPlayerEmote()
    if not canEmote then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"RPEmotes", errorMsg}
        })
        return
    end

    local placementState = GetPlacementState()
    if placementState == PlacementState.PREVIEWING or placementState == PlacementState.WALKING then return end

    -- Build payload (rebuild if cache invalidated)
    if not cachedPayload then
        cachedPayload = buildMenuPayload()
    else
        -- Always refresh dynamic data
        cachedPayload.keybinds = buildKeybindData()
        cachedPayload.emojis = buildEmojiData()
        cachedPayload.config = getRelevantConfig()
        local status = buildActiveStatus()
        for k, v in pairs(status) do cachedPayload[k] = v end
    end

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    SendNUIMessage(cachedPayload)
    isNuiMenuOpen = true
    startMenuInputThread()
end

-- ─── Rebuild functions (called from other files) ───

function InitMenu()
    -- Wait for all dependent systems to load
    while not (GetFavoriteEmotes and EmojiData and WalkMenuStart and GetKeyForCommand) do
        Wait(100)
    end
    -- NUI doesn't need pre-built menus; just mark as initialized
    cachedPayload = nil
    DebugPrint("[rpemotes] NUI menu system initialized")
end

function RebuildEmoteMenu()
    cachedPayload = nil  -- Invalidate cache so next open rebuilds
    if isNuiMenuOpen then
        -- Rebuild and resend if menu is currently open
        cachedPayload = buildMenuPayload()
        SendNUIMessage(cachedPayload)
    end
    DebugPrint("Menu rebuilt for model compatibility")
end

function RebuildKeybindEmoteMenu()
    if not Config.Keybinding then return end
    if isNuiMenuOpen then
        SendNUIMessage({
            action = "updateKeybinds",
            keybinds = buildKeybindData(),
        })
    end
end

-- Favorites are managed by NUI LocalStorage, no rebuild needed
function RebuildFavoritesEmoteMenu() end

-- Compatibility stubs for other files that reference these
function CloseAllMenus()
    if isNuiMenuOpen then
        CloseNUIMenu()
    end
end

function GetCurrentlyVisibleMenu()
    -- Return a stub for Placement.lua compatibility
    -- Placement.lua stores the result, hides it (Visible(false)), then restores it (Visible(true))
    if isNuiMenuOpen then
        return { Visible = function(self, val)
            if val == false then
                -- Hide NUI but don't fully close (keep state for restoration)
                SetNuiFocus(false, false)
                SendNUIMessage({ action = "closeMenu" })
                isNuiMenuOpen = false
            elseif val == true then
                -- Restore the NUI menu
                OpenEmoteMenu()
            end
        end }
    end
    return nil
end

function ProcessEmoteMenu()
    -- NUI handles its own event loop; this is a no-op
    -- Placement.lua calls this to restart menu processing after placement
    if not isNuiMenuOpen then return end
end

-- ─── NUI Callbacks ───

RegisterNUICallback('closeMenu', function(_, cb)
    CloseNUIMenu()
    cb({})
end)

RegisterNUICallback('playEmote', function(data, cb)
    handleEmoteSelection(data.name, data.emoteType, data.textureVariation)
    cb({})
end)

RegisterNUICallback('playSharedEmote', function(data, cb)
    SendSharedEmoteRequest(data.name)
    cb({})
end)

RegisterNUICallback('groupEmote', function(data, cb)
    OnGroupEmoteRequest(data.name)
    cb({})
end)

RegisterNUICallback('placeEmote', function(data, cb)
    if Config.PlacementEnabled then
        StartNewPlacement(data.name)
    end
    cb({})
end)

-- Favorites are now handled entirely in NUI LocalStorage

RegisterNUICallback('assignKeybind', function(data, cb)
    EmoteBindStart({data.slot, data.emoteName, data.label, data.emoteType})
    -- Send updated keybinds back to NUI
    local updatedKeybinds = buildKeybindData()
    SendNUIMessage({
        action = "updateKeybinds",
        keybinds = updatedKeybinds,
    })
    cb({ keybinds = updatedKeybinds })
end)

RegisterNUICallback('clearKeybind', function(data, cb)
    DeleteEmoteBind({data.slot})
    -- Send updated keybinds back to NUI
    local updatedKeybinds = buildKeybindData()
    SendNUIMessage({
        action = "updateKeybinds",
        keybinds = updatedKeybinds,
    })
    cb({ keybinds = updatedKeybinds })
end)

RegisterNUICallback('setWalkStyle', function(data, cb)
    if data.reset then
        ResetWalk()
        DeleteResourceKvp("walkstyle")
    else
        if not HasEmotePermission(data.name, EmoteType.WALKS) then
            ShowToast("You don't have permission to use this walk", 'error')
            cb({})
            return
        end
        WalkMenuStart(data.name)
    end
    sendActiveStatus()
    cb({})
end)

RegisterNUICallback('setExpression', function(data, cb)
    if data.reset then
        DeleteResourceKvp("expression")
        ClearFacialIdleAnimOverride(PlayerPedId())
    else
        if not HasEmotePermission(data.name, EmoteType.EXPRESSIONS) then
            ShowToast("You don't have permission to use this expression", 'error')
            cb({})
            return
        end
        EmoteMenuStart(data.name, nil, EmoteType.EXPRESSIONS)
    end
    sendActiveStatus()
    cb({})
end)

RegisterNUICallback('showEmoji', function(data, cb)
    ShowEmoji(data.name)
    cb({})
end)

RegisterNUICallback('previewEmote', function(data, cb)
    local emoteName = data.name
    local emoteType = data.emoteType

    if not Config.PreviewPed then
        cb({})
        return
    end

    -- Check if previewable
    if not isEmoteTypePreviewable(emoteType) then
        cb({})
        return
    end

    -- Same emote already previewing
    if LastEmote.name == emoteName and hasClonedPed() then
        cb({})
        return
    end

    local needsZoom = getPreviewZoomForEmoteType(emoteType)

    -- If zoom state changed, recreate ped
    if hasClonedPed() and currentZoomState ~= needsZoom then
        ClosePedMenu()
    end

    -- Clear previous preview
    if hasClonedPed() then
        ClearPedTaskPreview()
    end

    -- Update preview state
    LastEmote = {
        name = emoteName,
        emoteType = emoteType,
    }

    if hasClonedPed() then
        EmoteMenuStartClone(emoteName, emoteType)
    else
        currentZoomState = needsZoom
        ShowPedMenu(needsZoom)
        WaitForClonedPedThenPlayLastAnim()
    end

    cb({})
end)

RegisterNUICallback('stopPreview', function(_, cb)
    hidePreview()
    cb({})
end)

RegisterNUICallback('cancelEmote', function(_, cb)
    EmoteCancel()
    DestroyAllProps()
    cb({})
end)

-- Search focus: temporarily give full keyboard to NUI so typing works
RegisterNUICallback('searchFocus', function(_, cb)
    SetNuiFocusKeepInput(false)
    cb({})
end)

-- Search blur: restore KeepInput so game gets keyboard again
RegisterNUICallback('searchBlur', function(_, cb)
    if isNuiMenuOpen then
        SetNuiFocusKeepInput(true)
    end
    cb({})
end)

-- ─── Data initialization thread ───

CreateThread(function()
    LoadAddonEmotes()
    convertRP()

    -- Request permissions from server before creating menu
    TriggerServerEvent('rpemotes:server:requestPermissions')
    DebugPrint("[rpemotes] Requested permission manifest from server")
end)

-- ─── Idle cam monitoring thread ───

local idleCamActive = false

CreateThread(function()
    while true do
        Wait(500)
        -- While ped is dead or swimming, close menus
        local canEmote, _ = canPlayerEmote()
        if not canEmote then
            if IsInAnimation then
                EmoteCancel()
            end
            if isNuiMenuOpen then
                CloseNUIMenu()
            end
        end

        if Config.PreviewPed and isNuiMenuOpen then
            local camIsIdle = IsCinematicIdleCamRendering()

            if not idleCamActive and camIsIdle then
                idleCamActive = true
                ClosePedMenu()
            elseif idleCamActive and not camIsIdle then
                idleCamActive = false
                if LastEmote.name and not hasClonedPed() then
                    currentZoomState = getPreviewZoomForEmoteType(LastEmote.emoteType)
                    ShowPedMenu(currentZoomState)
                    WaitForClonedPedThenPlayLastAnim()
                end
            end
        end
    end
end)

-- ─── Wait for cloned ped thread ───

function WaitForClonedPedThenPlayLastAnim()
    if isWaitingForPed then return end

    isWaitingForPed = true
    CreateThread(function()
        local timeout = GetGameTimer() + 1500

        while GetGameTimer() < timeout and not hasClonedPed() do
            Wait(50)
        end

        if hasClonedPed() and LastEmote.name then
            EmoteMenuStartClone(LastEmote.name, LastEmote.emoteType)
        end

        isWaitingForPed = false
    end)
end
