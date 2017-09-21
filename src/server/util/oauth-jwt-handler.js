export default function CustomOAuthHandler (options = {}) {
  return function (req, res, next) {
    const app = req.app;
    console.log("Custom handler!", options);
    
    if (options.successRedirect) {
      res.hook = { data: {} };
      Object.defineProperty(res.hook.data, '__redirect', { value: { status: 302, url: options.successRedirect } });
    }

    next();
  };
}
