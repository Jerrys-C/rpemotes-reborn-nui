const TYPE_ICONS = {
    Dances: 'fa-solid fa-music',
    AnimalEmotes: 'fa-solid fa-paw',
    PropEmotes: 'fa-solid fa-cube',
    Shared: 'fa-solid fa-users',
    Emotes: 'fa-solid fa-masks-theater',
    Walks: 'fa-solid fa-person-walking',
    Expressions: 'fa-solid fa-masks-theater',
    Emojis: 'fa-solid fa-face-smile',
};

const EmoteList = {
    ITEM_HEIGHT: 34,
    COLS: 2,
    BUFFER: 8,
    MAX_POOL: 50,
    _scrollEl: null,
    _gridEl: null,
    _lastStart: -1,
    _lastEnd: -1,
    _scrollRAF: null,
    _hoverTimer: null,
    _activeProgressBar: null,
    _activePreviewKey: null,
    _previewSuppressedUntil: 0,
    _postScrollTimer: null,
    _lastMouseX: 0,
    _lastMouseY: 0,
    _selectedIndex: 0,
    _renderedCards: new Map(),
    _cardPool: [],
    _emptyEl: null,
    _variantDropdown: null,
    _variantDropdownCloseHandler: null,
    _contextMenu: null,
    _contextMenuCloseHandler: null,
    _tooltipEl: null,

    init() {
        this._scrollEl = document.getElementById('content-scroll');
        this._gridEl = document.getElementById('emote-grid');

        SmoothScroll.init(this._scrollEl);

        if (Store.config.commandTooltipEnabled) {
            this._tooltipEl = document.createElement('div');
            this._tooltipEl.className = 'cmd-tooltip';
            document.getElementById('emote-menu').appendChild(this._tooltipEl);
        } else {
            this._showTooltip = this._hideTooltip = () => {};
        }

        this._scrollEl.addEventListener('mousemove', (e) => {
            this._lastMouseX = e.clientX;
            this._lastMouseY = e.clientY;
        });

        this._scrollEl.addEventListener('scroll', () => {
            if (this._scrollRAF) return;
            this._scrollRAF = requestAnimationFrame(() => {
                this._scrollRAF = null;
                this._onScroll();
            });
        });

        window.addEventListener('resize', () => {
            this._measureItemHeight();
            this.render();
        });
    },

    _measureItemHeight() {
        const card = this._gridEl.querySelector('.emote-card');
        if (!card) return;

        const nextHeight = card.getBoundingClientRect().height + this._getRowGap();
        if (nextHeight > 10 && Math.abs(nextHeight - this.ITEM_HEIGHT) > 0.5) {
            this.ITEM_HEIGHT = nextHeight;
            this._lastStart = -1;
            this._lastEnd = -1;
            this._onScroll();
        }
    },

    _getRowGap() {
        const styles = window.getComputedStyle(this._gridEl);
        const gap = parseFloat(styles.getPropertyValue('--row-gap'));
        return Number.isFinite(gap) ? gap : 0;
    },

    render() {
        this._lastStart = -1;
        this._lastEnd = -1;
        this._selectedIndex = -1;
        this._previewSuppressedUntil = Date.now() + 250;
        this._cancelPendingHover();
        this._closeVariantDropdown();
        this._closeContextMenu();
        this._hideTooltip();
        this._clearRenderedCards();
        this._hideEmptyState();
        this._gridEl.style.height = '0px';
        SmoothScroll.reset();
        this._onScroll();
        requestAnimationFrame(() => this._measureItemHeight());
    },

    _onScroll() {
        const items = Store.filteredItems;
        const total = items.length;

        if (total === 0) {
            this._showEmptyState();
            return;
        }

        this._hideEmptyState();

        const totalRows = Math.ceil(total / this.COLS);
        const scrollTop = this._scrollEl.scrollTop;
        const vpHeight = this._scrollEl.clientHeight;
        const firstVisibleRow = Math.floor(scrollTop / this.ITEM_HEIGHT);
        const visibleRowCount = Math.ceil(vpHeight / this.ITEM_HEIGHT);
        const startRow = Math.max(0, firstVisibleRow - this.BUFFER);
        const endRow = Math.min(totalRows, firstVisibleRow + visibleRowCount + this.BUFFER);
        const start = startRow * this.COLS;
        const end = Math.min(total, endRow * this.COLS);

        this._gridEl.style.height = Math.max(0, (totalRows * this.ITEM_HEIGHT) - this._getRowGap()) + 'px';

        if (start === this._lastStart && end === this._lastEnd) return;
        this._lastStart = start;
        this._lastEnd = end;
        this._previewSuppressedUntil = Date.now() + 300;
        this._cancelPendingHover();
        this._hideTooltip();

        if (this._postScrollTimer) clearTimeout(this._postScrollTimer);
        this._postScrollTimer = setTimeout(() => {
            this._postScrollTimer = null;
            this._recheckHoverAtMouse();
        }, 350);

        for (const [index, card] of Array.from(this._renderedCards.entries())) {
            if (index < start || index >= end) {
                this._recycleCard(index, card);
            }
        }

        for (let i = start; i < end; i++) {
            const existing = this._renderedCards.get(i);
            if (existing) {
                this._syncCardState(existing, items[i], i);
                continue;
            }

            const card = this._acquireCard();
            this._updateCard(card, items[i], i);
            this._renderedCards.set(i, card);
            this._gridEl.appendChild(card);
        }
    },

    _showEmptyState() {
        this._clearRenderedCards();
        this._lastStart = 0;
        this._lastEnd = 0;

        if (!this._emptyEl) {
            this._emptyEl = document.createElement('div');
            this._emptyEl.className = 'empty-state';
        }

        this._emptyEl.textContent = Store.searchTerm
            ? (Store.t('searchnoresult') + ' "' + Store.searchTerm + '"')
            : Store.isCustomList(Store.currentCategory)
                ? (Store.t('emptylist') || 'Right-click emotes to add them here')
                : 'No items';
        this._gridEl.style.height = Math.max(this._scrollEl.clientHeight, 1) + 'px';

        if (this._emptyEl.parentNode !== this._gridEl || this._gridEl.childNodes.length !== 1) {
            this._gridEl.replaceChildren(this._emptyEl);
        }
    },

    _hideEmptyState() {
        if (this._emptyEl && this._emptyEl.parentNode === this._gridEl) {
            this._emptyEl.remove();
        }
    },

    _cancelPendingHover() {
        if (this._hoverTimer) {
            clearTimeout(this._hoverTimer);
            this._hoverTimer = null;
        }
        if (this._activeProgressBar) {
            if (this._activeProgressBar.parentNode) this._activeProgressBar.remove();
            this._activeProgressBar = null;
        }
    },

    _recheckHoverAtMouse() {
        if (!Store.isOpen) return;
        const el = document.elementFromPoint(this._lastMouseX, this._lastMouseY);
        const card = el?.closest?.('.emote-card');
        if (card && card.onmouseenter) card.onmouseenter();
    },

    _clearRenderedCards() {
        for (const [index, card] of Array.from(this._renderedCards.entries())) {
            this._recycleCard(index, card);
        }
    },

    _recycleCard(index, card) {
        if (!card) return;

        if (this._variantDropdown && card.contains(this._variantDropdown)) {
            this._closeVariantDropdown();
        }

        this._teardownCard(card);
        card.remove();
        this._renderedCards.delete(index);
        if (this._cardPool.length < this.MAX_POOL) this._cardPool.push(card);
    },

    _teardownCard(card) {
        card.replaceChildren();
        card.onclick = null;
        card.oncontextmenu = null;
        card.onmousedown = null;
        card.onmouseenter = null;
        card.onmouseleave = null;
        card.className = 'emote-card';
        card.removeAttribute('data-index');
        card.removeAttribute('data-cmd');
        card.style.top = '';
        card.style.left = '';
    },

    _acquireCard() {
        return this._cardPool.pop() || document.createElement('div');
    },

    _syncCardState(card, item, index) {
        const row = Math.floor(index / this.COLS);
        const col = index % this.COLS;
        card.dataset.index = String(index);
        card.style.top = (row * this.ITEM_HEIGHT) + 'px';
        card.style.left = col === 0 ? '0' : 'calc(50% + 1.5px)';
        card.classList.toggle('selected', index === this._selectedIndex);
        card.classList.toggle('disabled', item.hasPermission === false);
        card.classList.toggle('favorited', Store.isFavorite(item.name, item.emoteType));
    },

    _updateCard(card, item, index) {
        this._teardownCard(card);
        card.className = 'emote-card';
        this._syncCardState(card, item, index);

        if (item._isKeybind) {
            card.classList.add('keybind-card');
            if (item._isEmpty) card.classList.add('empty-slot');

            const slot = document.createElement('span');
            slot.className = 'card-slot';
            slot.textContent = item._slot;
            card.appendChild(slot);

            const lbl = document.createElement('span');
            lbl.className = 'card-label';
            lbl.textContent = item._isEmpty ? 'Empty' : item.label;
            card.appendChild(lbl);

            if (item.keyLabel) {
                const key = document.createElement('span');
                key.className = 'card-key';
                key.textContent = item.keyLabel;
                card.appendChild(key);
            }

            card.onclick = (e) => {
                if (!item._isEmpty) this._handleItemClick(item, e);
            };
            card.oncontextmenu = (e) => {
                e.preventDefault();
                if (!item._isEmpty) NUI.clearKeybind(item._slot);
            };
            return;
        }

        const icon = document.createElement('i');
        icon.className = 'card-icon ' + (TYPE_ICONS[item.emoteType] || '');
        card.appendChild(icon);

        const lbl = document.createElement('span');
        lbl.className = 'card-label';
        lbl.textContent = item.label || item.name;
        card.appendChild(lbl);

        const cmd = this._getCommand(item);
        if (cmd) card.dataset.cmd = cmd;

        if (item.propVariations && item.propVariations.length > 0) {
            const variant = document.createElement('span');
            variant.className = 'card-variant';
            variant.textContent = item.propVariations.length + 'v';
            card.appendChild(variant);

            card.onclick = () => {
                if (item.hasPermission === false) return;
                this._showPropVariantMenu(card, item);
            };
        } else {
            card.onclick = (e) => {
                if (item.hasPermission === false) return;
                this._handleItemClick(item, e);
            };
        }

        card.oncontextmenu = (e) => {
            e.preventDefault();
            this._showContextMenu(e, item, card);
        };

        card.onmousedown = (e) => {
            if (e.button === 1) {
                e.preventDefault();
                if (Store.config.keybindingEnabled) App.showKeybindModal(item);
            }
        };

        card.onmouseenter = () => {
            this._showTooltip(card);
            this._cancelPendingHover();

            if (item._isWalk || item._isEmoji || item.hasPermission === false) return;
            if (!Store.isOpen || Date.now() < this._previewSuppressedUntil) return;

            const previewKey = item.emoteType + ':' + item.name;
            if (this._activePreviewKey === previewKey) return;

            const bar = document.createElement('div');
            bar.className = 'preview-progress';
            card.appendChild(bar);
            this._activeProgressBar = bar;

            this._hoverTimer = setTimeout(() => {
                this._hoverTimer = null;
                if (this._activeProgressBar) {
                    if (this._activeProgressBar.parentNode) this._activeProgressBar.remove();
                    this._activeProgressBar = null;
                }

                if (!Store.isOpen) return;
                if (Date.now() < this._previewSuppressedUntil) return;
                if (this._activePreviewKey === previewKey) return;

                this._activePreviewKey = previewKey;
                NUI.previewEmote(item.name, item.emoteType);
            }, 500);
        };

        card.onmouseleave = () => {
            this._hideTooltip();
            this._cancelPendingHover();
        };

    },

    _handleItemClick(item, e) {
        this.stopPreview();
        if (e.shiftKey && !item._isWalk && !item._isExpression && !item._isEmoji) {
            NUI.placeEmote(item.name);
            return;
        }
        if (item._isWalk) return NUI.setWalkStyle(item.name);
        if (item._isExpression) return NUI.setExpression(item.name);
        if (item._isEmoji) return NUI.showEmoji(item.name);
        if (item.emoteType === 'Shared') return NUI.playSharedEmote(item.name);
        NUI.playEmote(item.name, item.emoteType);
    },

    _closeVariantDropdown() {
        if (this._variantDropdownCloseHandler) {
            document.removeEventListener('mousedown', this._variantDropdownCloseHandler, true);
            this._variantDropdownCloseHandler = null;
        }
        if (this._variantDropdown) {
            this._variantDropdown.remove();
            this._variantDropdown = null;
        }
    },

    _parseVariantName(raw) {
        if (!raw.includes('<')) return { color: null, text: raw };
        const doc = new DOMParser().parseFromString(raw, 'text/html');
        const font = doc.querySelector('font[color]');
        if (font) return { color: font.getAttribute('color'), text: font.textContent.trim() };
        return { color: null, text: doc.body.textContent.trim() || raw };
    },

    _showPropVariantMenu(cardEl, item) {
        this._closeVariantDropdown();
        this._hideTooltip();

        const dropdown = document.createElement('div');
        dropdown.className = 'variant-dropdown';
        this._variantDropdown = dropdown;

        const addOption = (text, color, value) => {
            const option = document.createElement('div');
            option.className = 'variant-option';
            option.textContent = text;
            if (color) option.style.color = color;
            option.dataset.value = value !== undefined ? value : '';
            dropdown.appendChild(option);
        };

        addOption('Default', null, '__default__');
        for (const variation of item.propVariations) {
            const { color, text } = this._parseVariantName(variation.Name || variation.name || '');
            const value = variation.Value !== undefined ? variation.Value : variation.value;
            addOption(text || ('Variant ' + value), color, value);
        }

        dropdown.onmousedown = (e) => {
            e.stopPropagation();
            e.preventDefault();
            const option = e.target.closest('.variant-option');
            if (!option) return;

            const value = option.dataset.value;
            this._closeVariantDropdown();
            this.stopPreview();
            this._previewSuppressedUntil = Date.now() + 800;

            if (value === '__default__') {
                NUI.playEmote(item.name, item.emoteType);
                return;
            }

            NUI.playEmote(item.name, item.emoteType, Number(value));
        };

        cardEl.appendChild(dropdown);

        setTimeout(() => {
            this._variantDropdownCloseHandler = (e) => {
                if (dropdown.parentNode && !dropdown.contains(e.target)) {
                    this._closeVariantDropdown();
                }
            };
            document.addEventListener('mousedown', this._variantDropdownCloseHandler, true);
        }, 0);
    },

    stopPreview() {
        this._cancelPendingHover();
        if (!this._activePreviewKey) return;

        this._activePreviewKey = null;
        NUI.stopPreview();
    },

    navigateUp() {
        const total = Store.filteredItems.length;
        if (total === 0) return;
        this._selectedIndex = this._selectedIndex >= this.COLS
            ? this._selectedIndex - this.COLS
            : total - 1;
        this._scrollToSelected();
    },

    navigateDown() {
        const total = Store.filteredItems.length;
        if (total === 0) return;
        this._selectedIndex = this._selectedIndex + this.COLS < total
            ? this._selectedIndex + this.COLS
            : 0;
        this._scrollToSelected();
    },

    navigateLeft() {
        const total = Store.filteredItems.length;
        if (total === 0) return;
        this._selectedIndex = this._selectedIndex > 0
            ? this._selectedIndex - 1
            : total - 1;
        this._scrollToSelected();
    },

    navigateRight() {
        const total = Store.filteredItems.length;
        if (total === 0) return;
        this._selectedIndex = this._selectedIndex < total - 1
            ? this._selectedIndex + 1
            : 0;
        this._scrollToSelected();
    },

    activateSelected() {
        const items = Store.filteredItems;
        if (this._selectedIndex < 0 || this._selectedIndex >= items.length) return;

        const item = items[this._selectedIndex];
        if (!item || item.hasPermission === false) return;
        if (item._isKeybind && item._isEmpty) return;

        if (item._isWalk) return NUI.setWalkStyle(item.name);
        if (item._isExpression) return NUI.setExpression(item.name);
        if (item._isEmoji) return NUI.showEmoji(item.name);
        if (item.emoteType === 'Shared') return NUI.playSharedEmote(item.name);
        NUI.playEmote(item.name, item.emoteType);
    },

    _scrollToSelected() {
        this._lastStart = -1;
        this._lastEnd = -1;

        const row = Math.floor(this._selectedIndex / this.COLS);
        const rowTop = row * this.ITEM_HEIGHT;
        const vpHeight = this._scrollEl.clientHeight;
        const currentScroll = this._scrollEl.scrollTop;

        if (rowTop < currentScroll) {
            SmoothScroll.scrollTo(rowTop);
        } else if (rowTop + this.ITEM_HEIGHT > currentScroll + vpHeight) {
            SmoothScroll.scrollTo(rowTop - vpHeight + this.ITEM_HEIGHT);
        }

        this._onScroll();
        this._cancelPendingHover();

        const item = Store.filteredItems[this._selectedIndex];
        if (!item || item._isKeybind || item._isWalk || item._isEmoji || item.hasPermission === false) {
            return;
        }

        const previewKey = item.emoteType + ':' + item.name;
        if (this._activePreviewKey === previewKey) return;

        this._hoverTimer = setTimeout(() => {
            this._hoverTimer = null;
            if (!Store.isOpen) return;
            if (Date.now() < this._previewSuppressedUntil) return;
            if (this._activePreviewKey === previewKey) return;

            this._activePreviewKey = previewKey;
            NUI.previewEmote(item.name, item.emoteType);
        }, 500);
    },

    // ── Tooltip ──

    _getCommand(item) {
        if (item._isKeybind || item._isEmoji) return null;
        if (item._isWalk) return '/walk ' + item.name.toLowerCase();
        if (item._isExpression) return '/mood ' + item.name.toLowerCase();
        return '/e ' + item.name;
    },

    _showTooltip(card) {
        const cmd = card.dataset.cmd;
        if (!cmd) { this._hideTooltip(); return; }

        this._tooltipEl.textContent = cmd;
        this._tooltipEl.classList.add('visible');

        const panelRect = document.getElementById('emote-menu').getBoundingClientRect();
        const cardRect = card.getBoundingClientRect();

        let x = cardRect.left + cardRect.width / 2 - panelRect.left;
        let y = cardRect.bottom - panelRect.top + 4;

        requestAnimationFrame(() => {
            if (!this._tooltipEl.classList.contains('visible')) return;
            const tw = this._tooltipEl.offsetWidth;
            const th = this._tooltipEl.offsetHeight;
            x = Math.max(tw / 2 + 4, Math.min(panelRect.width - tw / 2 - 4, x));
            if (y + th > panelRect.height - 4) y = cardRect.top - panelRect.top - th - 4;
            this._tooltipEl.style.left = x + 'px';
            this._tooltipEl.style.top = y + 'px';
        });

        this._tooltipEl.style.left = x + 'px';
        this._tooltipEl.style.top = y + 'px';
    },

    _hideTooltip() {
        if (this._tooltipEl) this._tooltipEl.classList.remove('visible');
    },

    // ── Context Menu ──

    _showContextMenu(e, item, card) {
        this._closeContextMenu();
        this._closeVariantDropdown();
        this._hideTooltip();

        const menu = document.createElement('div');
        menu.className = 'ctx-menu';

        const emoteId = item.emoteType + '_' + item.name;
        const emoteData = { name: item.name, label: item.label || item.name, emoteType: item.emoteType };

        // Favorite toggle
        const isFav = Store.isFavorite(item.name, item.emoteType);
        const favItem = this._createCtxItem(
            isFav ? 'fa-solid fa-star' : 'fa-regular fa-star',
            isFav ? (Store.t('btn_remove_favorite') || 'Remove Favorite') : (Store.t('btn_set_favorite') || 'Add Favorite'),
            isFav ? '#FFD60A' : null
        );
        favItem.addEventListener('click', () => {
            const isNowFav = Store.toggleFavorite(emoteId, emoteData);
            card.classList.toggle('favorited', isNowFav);
            const tkey = isNowFav ? 'addedtofavorites' : 'removedfromfavorites';
            Toast.show(Store.t(tkey).replace('%s', emoteData.label), isNowFav ? 'success' : 'info');
            if (Store.currentCategory === Store.FAVORITES) {
                App.updateSidebar();
                this.render();
            }
            this._closeContextMenu();
        });
        menu.appendChild(favItem);

        // Copy command
        const ctxCmd = this._getCommand(item);
        if (ctxCmd) {
            const copyItem = this._createCtxItem(
                'fa-regular fa-copy',
                Store.t('copycommand') || 'Copy Command',
                null
            );
            copyItem.addEventListener('click', () => {
                navigator.clipboard.writeText(ctxCmd).catch(() => {
                    const ta = document.createElement('textarea');
                    ta.value = ctxCmd;
                    ta.style.cssText = 'position:fixed;opacity:0';
                    document.body.appendChild(ta);
                    ta.select();
                    document.execCommand('copy');
                    ta.remove();
                });
                Toast.show((Store.t('copiedcommand') || 'Copied') + ': ' + ctxCmd, 'success');
                this._closeContextMenu();
            });
            menu.appendChild(copyItem);
        }

        // Custom lists
        const listIds = Object.keys(Store.customLists);
        if (listIds.length > 0) {
            menu.appendChild(this._createCtxDivider());
            for (const listId of listIds) {
                const list = Store.customLists[listId];
                const isIn = Store.isInCustomList(listId, item.name, item.emoteType);
                const listItem = this._createCtxItem(
                    'fa-solid fa-folder',
                    list.name,
                    list.color,
                    isIn
                );
                listItem.addEventListener('click', () => {
                    const isNowIn = Store.toggleCustomListItem(listId, emoteId, emoteData);
                    const msg = isNowIn
                        ? (Store.t('addedtolist') || '%s added to %l').replace('%s', emoteData.label).replace('%l', list.name)
                        : (Store.t('removedfromlist') || '%s removed from %l').replace('%s', emoteData.label).replace('%l', list.name);
                    Toast.show(msg, isNowIn ? 'success' : 'info');
                    if (Store.currentCategory === listId) {
                        App.updateSidebar();
                        this.render();
                    }
                    this._closeContextMenu();
                });
                menu.appendChild(listItem);
            }
        }

        // New list option
        menu.appendChild(this._createCtxDivider());
        const newItem = this._createCtxItem(
            'fa-solid fa-plus',
            Store.t('newlist') || 'New List...',
            null
        );
        newItem.addEventListener('click', () => {
            this._closeContextMenu();
            App.showListModal(null, item);
        });
        menu.appendChild(newItem);

        // Position within #emote-menu
        const panelEl = document.getElementById('emote-menu');
        panelEl.appendChild(menu);

        const panelRect = panelEl.getBoundingClientRect();
        let x = e.clientX - panelRect.left;
        let y = e.clientY - panelRect.top;

        requestAnimationFrame(() => {
            const ctxW = menu.offsetWidth;
            const ctxH = menu.offsetHeight;
            if (x + ctxW > panelRect.width - 4) x = panelRect.width - ctxW - 4;
            if (y + ctxH > panelRect.height - 4) y = panelRect.height - ctxH - 4;
            if (x < 4) x = 4;
            if (y < 4) y = 4;
            menu.style.left = x + 'px';
            menu.style.top = y + 'px';
        });

        menu.style.left = x + 'px';
        menu.style.top = y + 'px';

        this._contextMenu = menu;

        setTimeout(() => {
            this._contextMenuCloseHandler = (ev) => {
                if (!menu.contains(ev.target)) {
                    this._closeContextMenu();
                }
            };
            document.addEventListener('mousedown', this._contextMenuCloseHandler, true);
        }, 0);
    },

    _closeContextMenu() {
        if (this._contextMenuCloseHandler) {
            document.removeEventListener('mousedown', this._contextMenuCloseHandler, true);
            this._contextMenuCloseHandler = null;
        }
        if (this._contextMenu) {
            this._contextMenu.remove();
            this._contextMenu = null;
        }
    },

    _createCtxItem(iconClass, label, iconColor, checked) {
        const item = document.createElement('div');
        item.className = 'ctx-item';

        const icon = document.createElement('i');
        icon.className = 'ctx-icon ' + iconClass;
        if (iconColor) icon.style.color = iconColor;
        item.appendChild(icon);

        const text = document.createElement('span');
        text.className = 'ctx-label';
        text.textContent = label;
        item.appendChild(text);

        if (checked) {
            const check = document.createElement('i');
            check.className = 'ctx-check fa-solid fa-check';
            item.appendChild(check);
        }

        return item;
    },

    _createCtxDivider() {
        const div = document.createElement('div');
        div.className = 'ctx-divider';
        return div;
    }
};
