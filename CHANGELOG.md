# Changelog

## v2.0.4-ea.2 (2026-04-15)

### Bug Fixes (Cherry-picked from upstream)

- **Fixed hoe animations** (upstream `dbac5b7`)
- **Use `CanDoAction()` bridge function for pointing** - Fixed pointing not using the framework bridge function (upstream `6a70178`)

### Improvements

- **Added UI notification feedback for blocked emote/cancel states** - Players now receive a notification when emote or cancel actions are blocked, instead of being silently ignored
- **Default OneSync check behavior changed** - The `onesync` config variable now defaults to `"on"`, preventing unexpected behavior when not explicitly configured
