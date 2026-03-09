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
    _drag: { active: false, startX: 0, startY: 0, startLeft: 0, startTop: 0, savedPos: null },

    init() {
        this._menuEl = document.getElementById('emote-menu');
        this._sidebarEl = document.getElementById('sidebar');
        this._footerEl = document.getElementById('menu-footer');
        this._titleEl = document.getElementById('category-title');

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

        for (const cat of Store.categoryOrder) {
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

            this._sidebarEl.appendChild(item);
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

        if (cat === Store.WALKS) {
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
        h.push(Store.t('btn_set_favorite') || 'Right-click: Fav');
        h.push('\u2191\u2193 Nav');
        if (Store.config.keybindingEnabled) h.push(Store.t('btn_setkeybind') || 'Mid-click: Bind');
        this._footerEl.textContent = h.join(' \u00B7 ');
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

    _handleNavigate(direction) {
        switch (direction) {
            case 'up':     EmoteList.navigateUp(); break;
            case 'down':   EmoteList.navigateDown(); break;
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
