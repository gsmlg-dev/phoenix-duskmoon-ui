export const PhxWCHook = {
    mounted() {
        const attrs = this.el.attributes;
        const phxTarget = attrs["phx-target"].value;
        const pushEvent = phxTarget
        ? (event, payload, callback) =>
            this.pushEventTo(phxTarget, event, payload, callback)
        : this.pushEvent;

        for (var i = 0; i < attrs.length; i++) {
            if (/^phx-wc-send-/.test(attrs[i].name)) {
                const eventName = attrs[i].name.replace(/^phx-wc-send-/, "");
                const [phxEvent, callbackName] = attrs[i].value.split(';');
                this.el.addEventListener(eventName, ({ detail }) => {
                    pushEvent(phxEvent, detail, (e) => {
                        this[callbackName]?.(e, detail, eventName)
                    });
                });
            }
            if (/^phx-wc-receive-/.test(attrs[i].name)) {
                const eventName = attrs[i].name.replace(/^phx-wc-receive-/, "");
                const handler = attrs[i].value;
                this.handleEvent(eventName, (payload) => {
                    if (handler && this.el[handler]) {
                        this.el[handler]?.(payload);
                    } else {
                        this.el.dispatchEvent(new CustomEvent(eventName, { detail: payload }));
                    }
                });
            }
            if ('phx-wc-receive' === attrs[i].name) {
                const [phxEvent, callbackName] = attrs[i].value.split(';');
                this.handleEvent(phxEvent, (payload) => {
                    this.el[callbackName]?.(payload);
                });
            }
        }
    },
};


