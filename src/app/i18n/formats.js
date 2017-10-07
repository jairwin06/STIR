const Formats = {
    time: {
        "short": {
            minute: "numeric",
            second: "numeric"
        }
    },
    date: {
        graphDay:{
            day: 'numeric',
            month: 'short'
        },
        graphMonth:{
            month: 'short'
        },
        short: {
            year: "2-digit",
            month: "2-digit",
            day: "2-digit"
        }
    }
}

export default Formats;
