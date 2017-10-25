export default class STIRError extends Error {
  constructor(code = null, ...params) {
    super(...params);
    Error.captureStackTrace(this, STIRError);

    // Custom debugging information
    this.code = code;
  }
}
