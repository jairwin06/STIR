export default class UserStatusService {
    setup(app) {
        this.app = app;
    }
    find(params) {
        return Promise.resolve(params.user.status);
    }
}
