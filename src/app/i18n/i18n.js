import Messages from './messages'
import Formats from './formats'

export const BaseI18n = {
    messages : Messages,
    formats: Formats,
    locales: ['en','fr','de']
}


export function withTimezone(tz) {
    let formats = Object.assign({}, Formats);
    formats.time.short.timeZone = tz;
    let result = {
        messages: Messages,
        formats: formats,
        locales: ['en','fr','de']
    }
    return result;
}
