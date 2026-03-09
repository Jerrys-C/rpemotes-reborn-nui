const TOAST_ICONS = {
    success: 'fa-solid fa-circle-check',
    error:   'fa-solid fa-circle-xmark',
    warning: 'fa-solid fa-triangle-exclamation',
    info:    'fa-solid fa-circle-info',
};

const Toast = {
    MAX: 4,
    DEFAULT_MS: 3500,
    _el: null,

    init() {
        this._el = document.getElementById('toast-container');
    },

    show(msg, type = 'info', ms = this.DEFAULT_MS) {
        if (!this._el || !msg) return;
        type = TOAST_ICONS[type] ? type : 'info';

        // Drop oldest when at limit
        while (this._el.children.length >= this.MAX) {
            this._drop(this._el.lastElementChild);
        }

        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;

        const icon = document.createElement('i');
        icon.className = 'toast-icon ' + TOAST_ICONS[type];
        toast.appendChild(icon);

        const span = document.createElement('span');
        span.className = 'toast-msg';
        span.textContent = msg;
        toast.appendChild(span);

        const bar = document.createElement('div');
        bar.className = 'toast-bar';
        bar.style.animationDuration = ms + 'ms';
        toast.appendChild(bar);

        toast.addEventListener('click', () => this._drop(toast));
        toast._timer = setTimeout(() => this._drop(toast), ms);

        this._el.prepend(toast);
    },

    _drop(el) {
        if (!el || !el.parentNode) return;
        clearTimeout(el._timer);
        if (el.classList.contains('toast-leaving')) {
            el.remove();
            return;
        }
        el.classList.add('toast-leaving');
        el.addEventListener('animationend', () => el.remove(), { once: true });
    },

    clear() {
        if (!this._el) return;
        for (const el of Array.from(this._el.children)) this._drop(el);
    }
};

const App = {
    _menuEl: null,
    _sidebarEl: null,
    _footerEl: null,
    _titleEl: null,
    _statusEl: null,
    _drag: { active: false, startX: 0, startY: 0, startLeft: 0, startTop: 0, savedPos: null },

    init() {
        this._menuEl = document.getElementById('emote-menu');
        this._sidebarEl = document.getElementById('sidebar');
        this._footerEl = document.getElementById('menu-footer');
        this._titleEl = document.getElementById('category-title');
        this._statusEl = document.getElementById('status-bar');

        Toast.init();
        EmoteList.init();
        Search.init();

        window.addEventListener('message', (e) => this._onMessage(e));

        document.addEventListener('keydown', (e) => {
            if (!Store.isOpen) return;

            const si = document.getElementById('search-input');
            const inSearch = si && si === document.activeElement;

            switch (e.key) {
                case 'Escape':
                    if (inSearch) return;
                    NUI.closeMenu();
                    break;
                case 'ArrowUp':
                    if (!inSearch) {
                        e.preventDefault();
                        EmoteList.navigateUp();
                    }
                    break;
                case 'ArrowDown':
                    if (!inSearch) {
                        e.preventDefault();
                        EmoteList.navigateDown();
                    }
                    break;
                case 'ArrowLeft':
                    if (!inSearch) {
                        e.preventDefault();
                        EmoteList.navigateLeft();
                    }
                    break;
                case 'ArrowRight':
                    if (!inSearch) {
                        e.preventDefault();
                        EmoteList.navigateRight();
                    }
                    break;
                case 'Enter':
                    e.preventDefault();
                    if (inSearch) si.blur();
                    EmoteList.activateSelected();
                    break;
            }
        });

        document.getElementById('close-btn').addEventListener('click', () => NUI.closeMenu());
        document.getElementById('keybind-cancel').addEventListener('click', () => this.hideKeybindModal());
        document.addEventListener('contextmenu', (e) => e.preventDefault());

        const searchInput = document.getElementById('search-input');
        if (searchInput) {
            searchInput.addEventListener('focus', () => NUI.searchFocus());
            searchInput.addEventListener('blur', () => NUI.searchBlur());
        }

        this._initDrag();
    },

    _onMessage(event) {
        const d = event.data;
        if (!d || !d.action) return;
        switch (d.action) {
            case 'openMenu':      this._openMenu(d); break;
            case 'closeMenu':     this._closeMenu(); break;
            case 'showToast':     Toast.show(d.msg, d.toastType, d.duration); break;
            case 'updateKeybinds':
                Store.updateKeybinds(d.keybinds);
                this._refreshView();
                break;
            case 'updateStatus':
                Store.activeWalk = d.activeWalk || '';
                Store.activeWalkLabel = d.activeWalkLabel || '';
                Store.activeExpression = d.activeExpression || '';
                Store.activeExpressionLabel = d.activeExpressionLabel || '';
                this._updateStatusBar();
                break;
            case 'navigate':
                this._handleNavigate(d.direction);
                break;
        }
    },

    _openMenu(data) {
        Store.init(data);

        const si = document.getElementById('search-input');
        if (si) {
            si.placeholder = Store.t('searchemotes') || 'Search...';
            si.value = '';
        }

        this._buildSidebar();
        this._buildFooter();
        this._updateCategoryTitle();
        this._updateStatusBar();

        this._applyDragPosition();
        this._menuEl.classList.remove('hidden');
        Store.isOpen = true;
        EmoteList.render();
    },

    _closeMenu() {
        this._menuEl.classList.add('hidden');
        Store.isOpen = false;
        Search.clear();
        EmoteList.stopPreview();
        Toast.clear();
    },

    _refreshView() {
        this._updateCategoryTitle();
        EmoteList.render();
    },

    _buildSidebar() {
        this._sidebarEl.replaceChildren();

        let lastCustomIdx = -1;

        for (let i = 0; i < Store.categoryOrder.length; i++) {
            const cat = Store.categoryOrder[i];
            const item = document.createElement('div');
            item.className = 'sidebar-item';
            if (cat === Store.currentCategory) item.classList.add('active');
            item.dataset.category = cat;

            const icon = document.createElement('i');
            icon.className = 'sidebar-icon ' + Store.getCategoryIcon(cat);
            icon.style.color = Store.getCategoryColor(cat);
            item.appendChild(icon);

            const label = document.createElement('span');
            label.className = 'sidebar-label';
            label.textContent = this._shortLabel(cat);
            item.appendChild(label);

            item.addEventListener('click', () => {
                Search.clear();
                Store.setCategory(cat);
                this._setActiveCategory(cat);
                this._updateCategoryTitle();
                EmoteList.render();
                EmoteList.stopPreview();
            });

            if (Store.isCustomList(cat)) {
                lastCustomIdx = i;
                item.addEventListener('contextmenu', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    this.showListModal(cat);
                });
            }

            this._sidebarEl.appendChild(item);
        }

        // "+" button after favorites / custom lists
        const addItem = document.createElement('div');
        addItem.className = 'sidebar-item sidebar-add';
        const addIcon = document.createElement('i');
        addIcon.className = 'sidebar-icon fa-solid fa-plus';
        addItem.appendChild(addIcon);
        addItem.addEventListener('click', () => this.showListModal());

        const insertAfterIdx = lastCustomIdx >= 0 ? lastCustomIdx + 1 : 1;
        const refNode = this._sidebarEl.children[insertAfterIdx];
        if (refNode) {
            this._sidebarEl.insertBefore(addItem, refNode);
        } else {
            this._sidebarEl.appendChild(addItem);
        }
    },

    _shortLabel(cat) {
        const full = Store.getCategoryLabel(cat);
        const clean = full.replace(/^[\p{Emoji}\p{Emoji_Component}\s]+/u, '');
        return (clean || full).slice(0, 6);
    },

    _setActiveCategory(cat) {
        this._sidebarEl.querySelectorAll('.sidebar-item').forEach(el => {
            el.classList.toggle('active', el.dataset.category === cat);
        });
    },

    updateSidebar() {
        if (Store.searchTerm) {
            this._sidebarEl.querySelectorAll('.sidebar-item').forEach(el => el.classList.remove('active'));
            this._updateCategoryTitle();
        } else {
            this._setActiveCategory(Store.currentCategory);
            this._updateCategoryTitle();
        }
    },

    _updateCategoryTitle() {
        if (!this._titleEl) return;
        this._titleEl.replaceChildren();

        if (Store.searchTerm) {
            const count = Store.filteredItems.length;
            this._titleEl.textContent = count + ' results';
            return;
        }

        const cat = Store.currentCategory;
        const label = document.createTextNode(Store.getCategoryLabel(cat));
        this._titleEl.appendChild(label);

        const count = this._getCategoryCount(cat);
        if (count > 0) {
            const span = document.createElement('span');
            span.className = 'cat-count';
            span.textContent = '(' + count + ')';
            this._titleEl.appendChild(span);
        }

        if (Store.isCustomList(cat)) {
            const btn = document.createElement('button');
            btn.className = 'reset-btn';
            btn.textContent = Store.t('editlist') || 'Edit';
            btn.addEventListener('click', () => this.showListModal(cat));
            this._titleEl.appendChild(btn);
        } else if (cat === Store.WALKS) {
            const btn = document.createElement('button');
            btn.className = 'reset-btn';
            btn.textContent = Store.t('normalreset') || 'Reset';
            btn.addEventListener('click', () => NUI.resetWalkStyle());
            this._titleEl.appendChild(btn);
        } else if (cat === Store.EXPRESSIONS) {
            const btn = document.createElement('button');
            btn.className = 'reset-btn';
            btn.textContent = Store.t('normalreset') || 'Reset';
            btn.addEventListener('click', () => NUI.resetExpression());
            this._titleEl.appendChild(btn);
        }
    },

    _getCategoryCount(cat) {
        if (cat === Store.FAVORITES) return Object.keys(Store.favorites).length;
        if (Store.isCustomList(cat)) {
            const list = Store.customLists[cat];
            return list ? Object.keys(list.emotes).length : 0;
        }
        if (cat === Store.KEYBINDS)  return Store.keybinds.length;
        if (cat === Store.WALKS)     return Store.walks.length;
        if (cat === Store.EXPRESSIONS) return Store.expressions.length;
        if (cat === Store.EMOJIS)    return Store.emojis.length;
        if (Store.categories[cat])   return Store.categories[cat].length;
        return 0;
    },

    _buildFooter() {
        const h = [];
        h.push(Store.t('btn_select') || 'Click / Enter: Select');
        h.push(Store.t('btn_rightclick') || 'Right-click: Menu');
        h.push('\u2191\u2193 Nav');
        if (Store.config.keybindingEnabled) h.push(Store.t('btn_setkeybind') || 'Mid-click: Bind');
        this._footerEl.textContent = h.join(' \u00B7 ');
    },

    _updateStatusBar() {
        if (!this._statusEl) return;
        this._statusEl.replaceChildren();

        const hasWalk = !!Store.activeWalk;
        const hasExpr = !!Store.activeExpression;
        if (!hasWalk && !hasExpr) return;

        const card = document.createElement('div');
        card.className = 'status-card';

        if (hasWalk) {
            card.appendChild(this._createStatusItem(
                'fa-solid fa-person-walking', '#30D158',
                Store.activeWalkLabel || Store.activeWalk,
                () => { NUI.resetWalkStyle(); }
            ));
        }
        if (hasExpr) {
            card.appendChild(this._createStatusItem(
                'fa-solid fa-face-meh', '#5E5CE6',
                Store.activeExpressionLabel || Store.activeExpression,
                () => { NUI.resetExpression(); }
            ));
        }

        this._statusEl.appendChild(card);
    },

    _createStatusItem(iconClass, iconColor, label, onReset) {
        const item = document.createElement('div');
        item.className = 'status-item';

        const icon = document.createElement('i');
        icon.className = 'status-item-icon ' + iconClass;
        icon.style.color = iconColor;
        item.appendChild(icon);

        const lbl = document.createElement('span');
        lbl.className = 'status-item-label';
        lbl.textContent = label;
        item.appendChild(lbl);

        const btn = document.createElement('button');
        btn.className = 'status-item-reset';
        btn.textContent = '\u00D7';
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            onReset();
        });
        item.appendChild(btn);

        return item;
    },

    showKeybindModal(item) {
        const modal = document.getElementById('keybind-modal');
        const title = document.getElementById('keybind-modal-title');
        const slots = document.getElementById('keybind-slots');
        const cancel = document.getElementById('keybind-cancel');

        title.textContent = (Store.t('btn_setkeybind') || 'Assign Keybind') + ': ' + (item.label || item.name);
        cancel.textContent = Store.t('btn_back') || 'Cancel';
        slots.innerHTML = '';

        for (const kb of Store.keybinds) {
            const btn = document.createElement('button');
            btn.className = 'keybind-slot-btn';
            const existing = kb.emoteName ? (' (' + kb.label + ')') : ' (Empty)';
            btn.textContent = 'Slot ' + kb.slot + ': ' + kb.keyLabel + existing;
            btn.addEventListener('click', () => {
                NUI.assignKeybind(kb.slot, item.name, item.emoteType, item.label || item.name);
                this.hideKeybindModal();
            });
            slots.appendChild(btn);
        }

        modal.classList.remove('hidden');
    },

    hideKeybindModal() {
        document.getElementById('keybind-modal').classList.add('hidden');
    },

    // ── Custom List Modal ──

    _listModalState: null,
    _LIST_COLORS: ['#FF453A', '#FF9F0A', '#FFD60A', '#30D158', '#64D2FF', '#0A84FF', '#5E5CE6', '#FF375F'],

    showListModal(listId, autoAddItem) {
        const isEdit = !!listId;
        const list = isEdit ? Store.customLists[listId] : null;

        if (!isEdit && Object.keys(Store.customLists).length >= Store.MAX_CUSTOM_LISTS) {
            Toast.show(Store.t('maxlists') || 'Maximum number of lists reached', 'warning');
            return;
        }

        const modal = document.getElementById('list-modal');
        const title = document.getElementById('list-modal-title');
        const nameInput = document.getElementById('list-name-input');
        const colors = document.getElementById('list-color-picker');
        const saveBtn = document.getElementById('list-save-btn');
        const cancelBtn = document.getElementById('list-cancel-btn');
        const deleteBtn = document.getElementById('list-delete-btn');

        const iconEl = document.getElementById('list-modal-icon');

        title.textContent = isEdit ? (Store.t('editlist') || 'Edit List') : (Store.t('newlist') || 'New List');
        nameInput.value = isEdit ? list.name : '';
        nameInput.placeholder = Store.t('listname') || 'List name';

        let selectedColor = isEdit ? list.color : this._LIST_COLORS[0];

        const updateIconColor = (c) => {
            iconEl.style.background = c + '1A';
            iconEl.style.color = c;
        };
        updateIconColor(selectedColor);

        colors.replaceChildren();
        for (const c of this._LIST_COLORS) {
            const dot = document.createElement('div');
            dot.className = 'color-dot';
            if (c === selectedColor) dot.classList.add('active');
            dot.style.background = c;
            dot.addEventListener('click', () => {
                selectedColor = c;
                colors.querySelectorAll('.color-dot').forEach(d => d.classList.toggle('active', d === dot));
                updateIconColor(c);
            });
            colors.appendChild(dot);
        }

        deleteBtn.classList.toggle('hidden', !isEdit);
        deleteBtn.textContent = Store.t('deletelist') || 'Delete';
        saveBtn.textContent = isEdit ? (Store.t('savelist') || 'Save') : (Store.t('createlist') || 'Create');
        cancelBtn.textContent = Store.t('btn_back') || 'Cancel';

        this._listModalState = { listId, autoAddItem };

        saveBtn.onclick = () => {
            const name = nameInput.value.trim();
            if (!name) return;
            if (this._listModalState.listId) {
                Store.updateCustomList(this._listModalState.listId, name, selectedColor);
            } else {
                const id = Store.createCustomList(name, selectedColor);
                if (this._listModalState.autoAddItem) {
                    const it = this._listModalState.autoAddItem;
                    Store.toggleCustomListItem(id, it.emoteType + '_' + it.name, {
                        name: it.name, label: it.label || it.name, emoteType: it.emoteType
                    });
                }
            }
            this.hideListModal();
            this._buildSidebar();
            this._updateCategoryTitle();
        };

        cancelBtn.onclick = () => this.hideListModal();

        deleteBtn.onclick = () => {
            if (!this._listModalState.listId) return;
            this._showDeleteConfirm(nameInput.value.trim() || list.name);
        };

        nameInput.onfocus = () => NUI.searchFocus();
        nameInput.onblur = () => NUI.searchBlur();

        modal.classList.remove('hidden');
        nameInput.focus();
    },

    hideListModal() {
        document.getElementById('list-modal').classList.add('hidden');
        document.getElementById('list-modal-form').classList.remove('hidden');
        document.getElementById('list-confirm-delete').classList.add('hidden');
        this._listModalState = null;
        NUI.searchBlur();
    },

    _showDeleteConfirm(listName) {
        const form = document.getElementById('list-modal-form');
        const confirm = document.getElementById('list-confirm-delete');
        const title = document.getElementById('list-confirm-title');
        const msg = document.getElementById('list-confirm-msg');
        const backBtn = document.getElementById('list-confirm-back');
        const yesBtn = document.getElementById('list-confirm-yes');

        title.textContent = (Store.t('deletelist') || 'Delete') + ' "' + listName + '"?';
        msg.textContent = Store.t('cannotundo') || 'This action cannot be undone.';
        backBtn.textContent = Store.t('btn_back') || 'Cancel';
        yesBtn.textContent = Store.t('confirmdelete') || 'Delete';

        form.classList.add('hidden');
        confirm.classList.remove('hidden');

        backBtn.onclick = () => {
            confirm.classList.add('hidden');
            form.classList.remove('hidden');
        };

        yesBtn.onclick = () => {
            if (!this._listModalState || !this._listModalState.listId) return;
            Store.deleteCustomList(this._listModalState.listId);
            this.hideListModal();
            this._buildSidebar();
            this._setActiveCategory(Store.currentCategory);
            this._updateCategoryTitle();
            EmoteList.render();
        };
    },

    _handleNavigate(direction) {
        switch (direction) {
            case 'up':     EmoteList.navigateUp(); break;
            case 'down':   EmoteList.navigateDown(); break;
            case 'left':   EmoteList.navigateLeft(); break;
            case 'right':  EmoteList.navigateRight(); break;
            case 'select': EmoteList.activateSelected(); break;
            case 'back':   NUI.closeMenu(); break;
        }
    },

    _initDrag() {
        const handle = document.getElementById('drag-handle');
        if (!handle) return;

        handle.addEventListener('mousedown', (e) => {
            if (!Store.isOpen) return;
            e.preventDefault();

            const rect = this._menuEl.getBoundingClientRect();
            this._drag.active = true;
            this._drag.startX = e.clientX;
            this._drag.startY = e.clientY;
            this._drag.startLeft = rect.left;
            this._drag.startTop = rect.top;
            handle.classList.add('dragging');
        });

        document.addEventListener('mousemove', (e) => {
            if (!this._drag.active) return;

            const dx = e.clientX - this._drag.startX;
            const dy = e.clientY - this._drag.startY;
            let newLeft = this._drag.startLeft + dx;
            let newTop = this._drag.startTop + dy;

            // Keep at least 100px visible on screen
            const w = window.innerWidth;
            const h = window.innerHeight;
            const menuW = this._menuEl.offsetWidth || 300;
            newLeft = Math.max(-(menuW - 100), Math.min(w - 100, newLeft));
            newTop = Math.max(0, Math.min(h - 80, newTop));

            this._menuEl.style.left = newLeft + 'px';
            this._menuEl.style.top = newTop + 'px';
            this._menuEl.style.right = 'auto';
            this._menuEl.style.transform = 'none';
            this._menuEl.classList.add('dragged');

            this._drag.savedPos = { left: newLeft, top: newTop };
        });

        document.addEventListener('mouseup', () => {
            if (this._drag.active) {
                this._drag.active = false;
                const h = document.getElementById('drag-handle');
                if (h) h.classList.remove('dragging');
            }
        });
    },

    _applyDragPosition() {
        if (this._drag.savedPos) {
            let { left, top } = this._drag.savedPos;
            const w = window.innerWidth;
            const h = window.innerHeight;
            const menuW = this._menuEl.offsetWidth || 300;
            left = Math.max(-(menuW - 100), Math.min(w - 100, left));
            top = Math.max(0, Math.min(h - 80, top));
            this._drag.savedPos = { left, top };

            this._menuEl.style.left = left + 'px';
            this._menuEl.style.top = top + 'px';
            this._menuEl.style.right = 'auto';
            this._menuEl.style.transform = 'none';
            this._menuEl.classList.add('dragged');
        } else {
            this._menuEl.style.left = '';
            this._menuEl.style.top = '';
            this._menuEl.style.right = '';
            this._menuEl.style.transform = '';
            this._menuEl.classList.remove('dragged');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => App.init());
