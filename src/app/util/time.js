class TimeUtil {
    constructor() {
    }

    getDateMessageId(alarmTime) {
        let alarmDate = new Date(alarmTime);
        let today = new Date();
        let tomorrow = new Date();
        tomorrow.setDate(today.getDate() + 1);
        if (today.getDate() == alarmDate.getDate()) {
            return 'ALARM_TODAY';
        }
        else if (tomorrow.getDate() == alarmDate.getDate()) {
            return 'ALARM_TOMORROW';
        } else {
            return 'ALARM_DATE';
        }
    }

    getTimezone(locale) {
        let dtf = Intl.DateTimeFormat(locale, {timeZoneName: "short"});
        return dtf.formatToParts(new Date())[6].value;
    }
};

// Singleton
let instance = new TimeUtil();
export default instance;

