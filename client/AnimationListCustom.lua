-- Addon Emote Loader Framework
-- Drop .lua files into custom_emotes/ directory to auto-load custom animations.
--
-- Each file should have an ENABLED flag at the top:
--   local ENABLED = true  -- set to false to disable this pack
--   if not ENABLED then return end

---@type AnimationListConfig[]
local AddonEmotesList = {}

--- Register addon emote data to be merged into RP on load.
---@param addonData AnimationListConfig
function RegisterAddonEmotes(addonData)
    AddonEmotesList[#AddonEmotesList + 1] = addonData
end

function LoadAddonEmotes()
    for _, addon in ipairs(AddonEmotesList) do
        for arrayName, array in pairs(addon) do
            if RP[arrayName] then
                for emoteName, emoteData in pairs(array) do
                    RP[arrayName][emoteName] = emoteData
                end
            end
        end
    end

    AddonEmotesList = nil
end
