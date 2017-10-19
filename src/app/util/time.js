import jstz from 'jstimezonedetect'

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

    getAlarmTime(timeInput) {
        let timeComponents = timeInput.split(":");
        let alarmTime = new Date(new Date().setHours(timeComponents[0],timeComponents[1],0));

        if (alarmTime.getTime() < new Date().getTime()) {
            console.log("Alarm will be set for tomorrow");
            alarmTime.setDate(alarmTime.getDate() + 1);
        }
        alarmTime.setMilliseconds(0);
        return alarmTime;
    }

    getTimezone() {
        let dtf = Intl.DateTimeFormat();
        let timezone;

        if (dtf.resolvedOptions) {
            timezone = dtf.resolvedOptions().timeZone;
        }
        else {
            let tz = jstz.determine();
            timezone = tz.name();
        }
        console.log("User timezone: ", timezone);
        return timezone;
        
        /*
        else if (dtf.formatToParts) {
            return dtf.formatToParts(new Date())[6].value;
        } else {
            let tz = null;
            try {
                tz = (new Date).toString().split('(')[1].slice(0, -1);
            }
            catch (err) {
            }
            return tz || "LOCAL TIME";
        }
        return "LOCAL TIME"; */
    }

    getDefaultTime() {
        let defaultTime = new Date(new Date().setHours(9,0,0));
        defaultTime.setDate(defaultTime.getDate() + 1);
        defaultTime.setMilliseconds(0);
        return defaultTime;
    }
};

// Singleton
let instance = new TimeUtil();
export default instance;

