const Formats = {
    time: {
        "short": {
            hour: "numeric",
            minute: "numeric",
        }
    },
    date: {
        short: {
            year: "2-digit",
            month: "2-digit",
            day: "2-digit"
        },
        full: {
            weekday: 'long',
            month  : 'long',
            day    : 'numeric',
            year   : 'numeric',
            timeZoneName: 'short'
        }
    },
}

export default Formats;
