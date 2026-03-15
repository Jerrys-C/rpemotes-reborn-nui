# custom_emotes/

Drop `.lua` files into this directory to add custom animations. Each file has an `ENABLED` flag at the top — set it to `false` to disable without removing the file.

## Structure

A pack can be a single file or split into animations + category:

```
custom_emotes/
├── mypack_animations.lua   -- animation data (required)
└── mypack_category.lua     -- menu category grouping (optional)
```

## Animation file

```lua
-- My Animation Pack

local ENABLED = true -- set to false to disable this pack
if not ENABLED then return end

local CustomDP = {}

CustomDP.Emotes = {
    ["myemote"] = {
        "my@anim@dict",
        "my@anim@clip",
        "Emote Label",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
}
-- Available tables: Emotes, Shared, PropEmotes, Dances, Expressions, Walks, AnimalEmotes, Exits

RegisterAddonEmotes(CustomDP)
```

## Category file

Groups emotes into a custom menu section.

```lua
-- My Animation Pack - Category

local ENABLED = true -- set to false to disable this category
if not ENABLED then return end

Config.CustomCategories["My Emotes"] = {
    [EmoteType.EMOTES] = { "myemote1", "myemote2" },
    [EmoteType.PROP_EMOTES] = { "myprop1" },
    [EmoteType.SHARED] = { "myshared1" },
}
```

## Notes

- Packs without a category file will have their emotes appear in the default type-based categories.
- When disabling a pack, remember to disable both the animation and category files.
