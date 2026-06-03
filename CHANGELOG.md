# Changelog

## v2.1.1-ea.1 (2026-06-03)

Synced functional fixes from upstream up to `2.1.1`, excluding all UI/NUI changes (this fork uses its own `html/` NUI). Version aligned to upstream `2.1.1` with the fork's `-ea.1` pre-release suffix.

### Bug Fixes (Cherry-picked from upstream)

- **Gracefully clear scenarios while in vehicles** (upstream `a6205ce`)
- **Fix keybind functions in `animations:` events** - Bridge was calling non-existent `DeleteEmote`/`ListKeybinds` and a wrong `EmoteBindStart` signature (upstream `f2a8c01`)
- **Add missing arguments to various natives** (`SetCamRot`, `IsPedInAnyVehicle`, `SetFacialIdleAnimOverride`, fixed undefined `ped` var in `CleanUpPlacement`) (upstream `d5b9bd9`)
- **Correctly start newscam and binoculars anims** (upstream `791281c`)
- **Player ped now turns with the camera** while using binoculars/newscam (upstream `8d51e92`)
- **Use correct native name for ambient sound** in binoculars/newscam (upstream `9d273ac`)
- **Block emotes/expressions/emojis when ped is busy or dead**; default prop texture variation to `1` on `/e` (non-UI parts of upstream `#300`)

### Improvements

- **Expose `StartNewPlacement` and `GetPlacementState` as exports** (upstream `425f10d`)
- **Model compatibility update** - added new Popcorn RP pet models (upstream `ed92c06`)

### Maintenance

- **Update checker now points to this fork** (`Jerrys-C/rpemotes-reborn-nui`) instead of upstream, so it no longer reports outdated against upstream releases
- Removed redundant `lua54` field from `fxmanifest` (upstream `d9db2ef`)

## v2.0.4-ea.2 (2026-04-15)

### Bug Fixes (Cherry-picked from upstream)

- **Fixed hoe animations** (upstream `dbac5b7`)
- **Use `CanDoAction()` bridge function for pointing** - Fixed pointing not using the framework bridge function (upstream `6a70178`)

### Improvements

- **Added UI notification feedback for blocked emote/cancel states** - Players now receive a notification when emote or cancel actions are blocked, instead of being silently ignored
- **Default OneSync check behavior changed** - The `onesync` config variable now defaults to `"on"`, preventing unexpected behavior when not explicitly configured
