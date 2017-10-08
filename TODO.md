### TODOs
| Filename | line # | TODO
|:------|:------:|:------
| app/routes.js | 25 | Webpack lazy loading?
| app/stores/auth.js | 71 | If this fails then the JWT cookie is cleared and a new user will be created. is this ok?
| app/util/recorder.js | 52 | Using 8000 samplerate wav for now because it's same as Trilio.
| server/services/alarm-manager.js | 166 | Backup alarms , only on first usage
| server/services/fbanalyze.js | 73 | Paging
| server/services/generate-prompt.js | 78 | Retry when twitter is not available, and any other error?
| server/util/sox.js | 27 | Test this on iPhone/Android