export default function(...args) {
    return function(hook) {
        if (hook.params.provider) {
            for (key in hook.data) {
                console.log(key);
                if (!args.includes(key)) {
                    delete hook.data[key];
                }
            }
        }
        return hook;
    }
}
