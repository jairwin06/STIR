import Messages from './messages'
import Formats from './formats'

const base = {
    messages : Messages,
    formats: Formats,
    locales: ['en','fr','de']
}

export default base;

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
