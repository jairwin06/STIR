export default class UIUtil {
    constructor(intl) {
        this.intl = intl;
    }
    showError(errorText) {
        phonon.alert(errorText, this.intl.formatMessage('ERROR_TITLE'), false, "Ok");
    }
};

