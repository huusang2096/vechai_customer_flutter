fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### build_flutter
```
fastlane build_flutter
```


----

## Android
### android build_release
```
fastlane android build_release
```
Deploy to Firebase App Distribution
### android upload_firebase
```
fastlane android upload_firebase
```

### android deploy_firebase
```
fastlane android deploy_firebase
```

### android deploy_playstore
```
fastlane android deploy_playstore
```

### android upload_playstore
```
fastlane android upload_playstore
```


----

## iOS
### ios setup_keychain
```
fastlane ios setup_keychain
```

### ios build_adhoc
```
fastlane ios build_adhoc
```
Description of what the lane does
### ios upload_firebase
```
fastlane ios upload_firebase
```

### ios build_appstore
```
fastlane ios build_appstore
```

### ios upload_testflight
```
fastlane ios upload_testflight
```

### ios deploy_firebase
```
fastlane ios deploy_firebase
```

### ios deploy_testflight
```
fastlane ios deploy_testflight
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
