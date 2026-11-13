# style_me

Style me app.

## Getting Started
### Prerequisites
- Flutter version: `3.27.1`
- Android Studio installed
- files from encrypted zip
	- .env 
	- for android folder:
		- .keystore
		- key.properties


### Setup Project:
Start by getting the dependencies and generating the files:

```bash
 flutter pub get
 dart run build_runner build -d
```

### Ios setup

Open ios simulator [(you need have xcode installed)](https://apps.apple.com/us/app/xcode/id497799835?mt=12),
you can also learn more [here](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device).

Make sure that you have 
```bash
 sudo gem install cocoapods
 cd ./ios/
 pod install
```

Make sure that in the upper right corner, to the left of the `main.dart` label, the device or simulator on which you want to run is selected.

If you want to launch the project on a physical device, check out the tutorial for [iOS](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device#Connect-real-devices-to-your-Mac) or [Android](https://developer.android.com/studio/run/device#setting-up).

When everything is ready, you can launch the app by clicking the button in the upper right corner to the right of the `main.dart` label. Or from terminal like: 
```bash
 flutter run
```

#### NOTES: 
- Deep links do not work on iOS because this service requires the Apple Developer Program, which is a paid service. New account confirmation is only available on Android or through database manipulation.
- To use image generation (VTON/checkroom), you need to enable the machine on GCP. [See tutorial](https://drive.google.com/file/d/1ZF4g8UUeU7HbxJr8nwa5kO-3ei67U5FV/view). The correct service account is: `Computer Engine default service account`
- We use free resources on gcp, which is why the backend will take a long time to respond to the first request.
The same applies when adding the first photo (the machine with classifiers starts up).



