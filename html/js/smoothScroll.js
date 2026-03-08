const SmoothScroll = {
    _el: null,
    _target: 0,
    _current: 0,
    _animating: false,
    _lerp: 0.12,
    _wheelMultiplier: 0.45,

    init(el) {
        this._el = el;
        this._current = 0;
        this._target = 0;

        el.addEventListener('wheel', (e) => {
            e.preventDefault();
            e.stopPropagation();

            let delta = e.deltaY;
            if (e.deltaMode === 1) delta *= 36;
            delta *= this._wheelMultiplier;

            const max = el.scrollHeight - el.clientHeight;
            this._target = Math.max(0, Math.min(max, this._target + delta));

            if (!this._animating) this._animate();
        }, { passive: false });
    },

    _animate() {
        this._animating = true;

        const tick = () => {
            const diff = this._target - this._current;

            if (Math.abs(diff) < 0.5) {
                this._current = this._target;
                this._el.scrollTop = this._current;
                this._animating = false;
                return;
            }

            this._current += diff * this._lerp;
            this._el.scrollTop = Math.round(this._current);
            requestAnimationFrame(tick);
        };

        requestAnimationFrame(tick);
    },

    reset() {
        this._target = 0;
        this._current = 0;
        this._animating = false;
        if (this._el) this._el.scrollTop = 0;
    },

    scrollTo(pos) {
        const max = this._el.scrollHeight - this._el.clientHeight;
        this._target = Math.max(0, Math.min(max, pos));
        if (!this._animating) this._animate();
    }
};
