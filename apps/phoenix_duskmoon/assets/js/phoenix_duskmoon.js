import '@gsmlg/lit';

window.addEventListener('modal:open', (evt) => {
    const modal = evt.target;
    if (modal.open) {
        return;
    }
    const x = evt.pageX;
    const y = evt.pageY;
    modal.style.setProperty("--x", `calc(-50vw + ${x}px)`);
    modal.style.setProperty("--y", `calc(-50vh + ${y}px)`);
    modal.showModal();
    modal.addEventListener('modal:close', (evt) => {
        modal.setAttribute("closing", "");
        modal.addEventListener(
            "animationend",
            () => {
            modal.removeAttribute("closing");
            modal.close();
            },
            { once: true }
        );
    }, {
        once: true
    });
});

export const WebComponentHook = {
    mounted() {
        const attrs = this.el.attributes;
        const phxTarget = attrs["phx-target"].value;
        const pushEvent = phxTarget
        ? (event, payload, callback) =>
            this.pushEventTo(phxTarget, event, payload, callback)
        : this.pushEvent;

        for (var i = 0; i < attrs.length; i++) {
            if (/^darkmoon-send-/.test(attrs[i].name)) {
                const eventName = attrs[i].name.replace(/^darkmoon-send-/, "");
                const [phxEvent, callbackName] = attrs[i].value.split(';');
                this.el.addEventListener(eventName, ({ detail }) => {
                    pushEvent(phxEvent, detail, (e) => {
                        this[callbackName]?.(e, detail, eventName)
                    });
                });
            }
            if (/^darkmoon-receive-/.test(attrs[i].name)) {
                const eventName = attrs[i].name.replace(/^darkmoon-receive-/, "");
                const handler = attrs[i].value;
                this.handleEvent(eventName, (payload) => {
                    if (handler && this.el[handler]) {
                        this.el[handler]?.(payload);
                    } else {
                        this.el.dispatchEvent(new CustomEvent(eventName, { detail: payload }));
                    }
                });
            }
            if ('darkmoon-receive' === attrs[i].name) {
                const [phxEvent, callbackName] = attrs[i].value.split(';');
                this.handleEvent(phxEvent, (payload) => {
                    this.el[callbackName]?.(payload);
                });
            }
        }
    },
};

if (window) {
    window.__WebComponentHook__ = WebComponentHook;
}
