const Search = {
    _timer: null,
    _debounceMs: 150,

    init() {
        const input = document.getElementById('search-input');
        const clearBtn = document.getElementById('search-clear');
        if (!input) return;

        input.addEventListener('keydown', (e) => {
            if (e.repeat) {
                e.preventDefault();
                return;
            }
        });

        input.addEventListener('input', (e) => {
            this._debounce(e.target.value);
            this._toggleClear(e.target.value);
        });

        input.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                e.preventDefault();
                e.stopPropagation();
                if (input.value) {
                    input.value = '';
                    this._apply('');
                    this._toggleClear('');
                } else {
                    NUI.closeMenu();
                }
            }
        });

        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                input.value = '';
                this._apply('');
                this._toggleClear('');
                input.focus();
            });
        }
    },

    _toggleClear(value) {
        const btn = document.getElementById('search-clear');
        if (btn) btn.classList.toggle('hidden', !value);
    },

    _debounce(term) {
        if (this._timer) clearTimeout(this._timer);
        this._timer = setTimeout(() => this._apply(term), this._debounceMs);
    },

    _apply(term) {
        Store.setSearchTerm(term);
        EmoteList.render();
        App.updateSidebar();
    },

    clear() {
        const input = document.getElementById('search-input');
        if (input) input.value = '';
        if (this._timer) clearTimeout(this._timer);
        Store.setSearchTerm('');
        this._toggleClear('');
    }
};
