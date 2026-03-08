const _resourceName = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName()
    : 'rpemotes-reborn';

const NUI = {
    callback(name, data = {}) {
        return fetch(`https://${_resourceName}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        }).then(resp => resp.json()).catch(() => ({}));
    },

    closeMenu()                                 { return this.callback('closeMenu'); },
    playEmote(name, emoteType, textureVariation) { return this.callback('playEmote', { name, emoteType, textureVariation }); },
    playSharedEmote(name)                       { return this.callback('playSharedEmote', { name }); },
    placeEmote(name)                            { return this.callback('placeEmote', { name }); },
    assignKeybind(slot, emoteName, emoteType, label) { return this.callback('assignKeybind', { slot, emoteName, emoteType, label }); },
    clearKeybind(slot)                          { return this.callback('clearKeybind', { slot }); },
    setWalkStyle(name)                          { return this.callback('setWalkStyle', { name }); },
    resetWalkStyle()                            { return this.callback('setWalkStyle', { reset: true }); },
    setExpression(name)                         { return this.callback('setExpression', { name }); },
    resetExpression()                           { return this.callback('setExpression', { reset: true }); },
    showEmoji(name)                             { return this.callback('showEmoji', { name }); },
    previewEmote(name, emoteType)               { return this.callback('previewEmote', { name, emoteType }); },
    stopPreview()                               { return this.callback('stopPreview'); },
    cancelEmote()                               { return this.callback('cancelEmote'); },
    searchFocus()                               { return this.callback('searchFocus'); },
    searchBlur()                                { return this.callback('searchBlur'); },
};
