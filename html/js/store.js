const Store = {
    categories: {},
    favorites: {},
    keybinds: [],
    walks: [],
    expressions: [],
    emojis: [],
    config: {},
    translations: {},
    currentCategory: null,
    searchTerm: '',
    filteredItems: [],
    isOpen: false,
    categoryOrder: [],

    FAVORITES: '__favorites__',
    KEYBINDS: '__keybinds__',
    WALKS: '__walks__',
    EXPRESSIONS: '__expressions__',
    EMOJIS: '__emojis__',
    _LS_PREFIX: 'rpemotes:',
    _GTA_CODE_RE: /~[a-zA-Z]~/g,

    init(data) {
        this.categories = data.categories || {};
        this.favorites = this._loadFavorites();
        this.keybinds = data.keybinds || [];
        this.walks = data.walks || [];
        this.expressions = data.expressions || [];
        this.emojis = data.emojis || [];
        this.config = data.config || {};
        this.translations = data.translations || {};
        this.searchTerm = '';

        this._buildCategoryOrder();
        const saved = localStorage.getItem(this._LS_PREFIX + 'category');
        this.currentCategory = (saved && this.categoryOrder.includes(saved))
            ? saved
            : this.categoryOrder[0] || null;
        this.isOpen = true;

        this._updateFilteredItems();
    },

    _buildCategoryOrder() {
        this.categoryOrder = [];
        this.categoryOrder.push(this.FAVORITES);

        const catNames = Object.keys(this.categories);
        for (const name of catNames) {
            this.categoryOrder.push(name);
        }

        if (this.config.keybindingEnabled) {
            this.categoryOrder.push(this.KEYBINDS);
        }
        if (this.walks.length > 0) {
            this.categoryOrder.push(this.WALKS);
        }
        if (this.expressions.length > 0) {
            this.categoryOrder.push(this.EXPRESSIONS);
        }
        if (this.emojis.length > 0) {
            this.categoryOrder.push(this.EMOJIS);
        }
    },

    _strip(s) {
        return s.replace(this._GTA_CODE_RE, '').trim();
    },

    getCategoryLabel(cat) {
        if (cat === this.FAVORITES) return this._strip(this.translations.favorites || 'Favorites');
        if (cat === this.KEYBINDS) return this._strip(this.translations.keybinds || 'Keybinds');
        if (cat === this.WALKS) return this._strip(this.translations.walkingstyles || 'Walk Styles');
        if (cat === this.EXPRESSIONS) return this._strip(this.translations.moods || 'Moods');
        if (cat === this.EMOJIS) return this._strip(this.translations.emojis || 'Emojis');
        return this._strip(cat);
    },

    getCategoryIcon(cat) {
        if (cat === this.FAVORITES)   return 'fa-solid fa-star';
        if (cat === this.KEYBINDS)    return 'fa-solid fa-keyboard';
        if (cat === this.WALKS)       return 'fa-solid fa-person-walking';
        if (cat === this.EXPRESSIONS) return 'fa-solid fa-face-meh';
        if (cat === this.EMOJIS)      return 'fa-solid fa-face-smile';

        const t = this.translations;
        if (t.danceemotes && cat === t.danceemotes) return 'fa-solid fa-music';
        if (t.propemotes  && cat === t.propemotes)  return 'fa-solid fa-cube';
        if (t.shareemotes && cat === t.shareemotes) return 'fa-solid fa-handshake';
        if (t.emotes      && cat === t.emotes)      return 'fa-solid fa-masks-theater';

        return 'fa-solid fa-folder-open';
    },

    getCategoryColor(cat) {
        if (cat === this.FAVORITES)   return '#FFD60A';
        if (cat === this.KEYBINDS)    return '#64D2FF';
        if (cat === this.WALKS)       return '#30D158';
        if (cat === this.EXPRESSIONS) return '#5E5CE6';
        if (cat === this.EMOJIS)      return '#FF9F0A';

        const t = this.translations;
        if (t.danceemotes && cat === t.danceemotes) return '#FF2D55';
        if (t.propemotes  && cat === t.propemotes)  return '#FF9F0A';
        if (t.shareemotes && cat === t.shareemotes) return '#30D158';
        if (t.emotes      && cat === t.emotes)      return '#BF5AF2';

        return '#8E8E93';
    },

    setCategory(cat) {
        this.currentCategory = cat;
        this.searchTerm = '';
        localStorage.setItem(this._LS_PREFIX + 'category', cat);
        this._updateFilteredItems();
    },

    setSearchTerm(term) {
        this.searchTerm = term;
        this._updateFilteredItems();
    },

    _updateFilteredItems() {
        const term = this.searchTerm.toLowerCase().trim();

        if (term) {
            this.filteredItems = [];
            for (const [catName, emotes] of Object.entries(this.categories)) {
                for (const emote of emotes) {
                    if (this._matchesSearch(emote, term)) {
                        this.filteredItems.push({ ...emote });
                    }
                }
            }
            for (const w of this.walks) {
                if (this._matchesSearch(w, term)) {
                    this.filteredItems.push({ name: w.name, label: w.label, emoteType: 'Walks', _isWalk: true });
                }
            }
            for (const e of this.expressions) {
                if (this._matchesSearch(e, term)) {
                    this.filteredItems.push({ name: e.name, label: e.label, emoteType: 'Expressions', _isExpression: true });
                }
            }
            for (const ej of this.emojis) {
                if (this._matchesSearch(ej, term)) {
                    this.filteredItems.push({ name: ej.name, label: ej.label, emoteType: 'Emojis', _isEmoji: true });
                }
            }
            this.filteredItems.sort((a, b) => (a.label || a.name).localeCompare(b.label || b.name));
            return;
        }

        const cat = this.currentCategory;

        if (cat === this.FAVORITES) {
            this.filteredItems = Object.values(this.favorites);
        } else if (cat === this.KEYBINDS) {
            this.filteredItems = this.keybinds.map(kb => ({
                name: kb.emoteName || '',
                label: kb.label || ('Slot ' + kb.slot + ': Empty'),
                emoteType: kb.emoteType || '',
                keyLabel: kb.keyLabel || '',
                _isKeybind: true,
                _slot: kb.slot,
                _isEmpty: !kb.emoteName
            }));
        } else if (cat === this.WALKS) {
            this.filteredItems = this.walks.map(w => ({
                name: w.name,
                label: w.label || w.name,
                emoteType: 'Walks',
                hasPermission: w.hasPermission !== false,
                _isWalk: true
            }));
        } else if (cat === this.EXPRESSIONS) {
            this.filteredItems = this.expressions.map(e => ({
                name: e.name,
                label: e.label || e.name,
                emoteType: 'Expressions',
                hasPermission: e.hasPermission !== false,
                _isExpression: true
            }));
        } else if (cat === this.EMOJIS) {
            this.filteredItems = this.emojis.map(e => ({
                name: e.name,
                label: e.label || e.name,
                emoteType: 'Emojis',
                _isEmoji: true
            }));
        } else if (this.categories[cat]) {
            this.filteredItems = [...this.categories[cat]];
        } else {
            this.filteredItems = [];
        }
    },

    _matchesSearch(emote, term) {
        return (emote.name && emote.name.toLowerCase().includes(term))
            || (emote.label && emote.label.toLowerCase().includes(term));
    },

    _loadFavorites() {
        try {
            return JSON.parse(localStorage.getItem(this._LS_PREFIX + 'favorites')) || {};
        } catch { return {}; }
    },

    _saveFavorites() {
        localStorage.setItem(this._LS_PREFIX + 'favorites', JSON.stringify(this.favorites));
    },

    toggleFavorite(id, data) {
        if (this.favorites[id]) {
            delete this.favorites[id];
        } else {
            this.favorites[id] = data;
        }
        this._saveFavorites();
        if (this.currentCategory === this.FAVORITES) {
            this._updateFilteredItems();
        }
        return !!this.favorites[id];
    },

    updateKeybinds(keybinds) {
        this.keybinds = keybinds || [];
        if (this.currentCategory === this.KEYBINDS) {
            this._updateFilteredItems();
        }
    },

    isFavorite(name, emoteType) {
        const id = emoteType + '_' + name;
        return !!this.favorites[id];
    },

    t(key) {
        return this._strip(this.translations[key] || key);
    }
};
