<p align="center">
<img src="https://play-lh.googleusercontent.com/fZOqy_Q4XQIBKpoUYpy9LIIOSWwjZMQLpZJOv3WAoL9tyy-yQbV7X0Ke-bnGT_CeIsq-=w240-h480-rw" alt="CSIndiaMobileApp"/>
</p>

# Credit Saison India: Loan App

<div width="50%">
<div width="100%">
<a href="https://apps.apple.com/us/app/privo-instant-credit-line-app/id6450202147">
<img src="https://www.pngmart.com/files/10/Download-On-The-App-Store-PNG-Image.png" width = 150 /></a>
</div>
<div width="100%">
<a  href="https://play.google.com/store/apps/details?id=com.privo.creditsaison" >
<img src="https://www.freepnglogos.com/uploads/play-store-logo-png/play-store-logo-nisi-filters-australia-11.png" width = 150  /></a>
</div>
</div>


## Technology Used

- [Flutter](https://flutter.dev)
- [Dart](https://dart.dev)
- Java for Native Android
- Swift for Native iOS


## Installation

Download the stable version 3.27.0 of Flutter from https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.27.0-stable.zip

Download `arm64` for M1 Silicon Chip and `x64` for Intel Chip.

Open Finder, Create a folder `development`(it can be anything) in your username folder.

Extract the downloaded SDK in the `development` folder.

Download and install Android Studio or VS Code and XCode.

## Setting up the PATH
Open system terminal and type the following command `nano ~/.zshrc`. It will open a editor.

Copy and paste this:
`export PATH="$PATH:/Users/{username}/development/flutter/bin"`
<b>Don't forget to change the username</b>.

Click `Ctrl+X` and click `Enter`.

Now Execute the `source ~/.zshrc`. Close and open a new terminal.

Run `flutter doctor` to check if the PATH has been defined properly.

## Setting up Firebase
Download the .firebase folder from [gDrive](https://drive.google.com/drive/folders/19bL1EKDxuvn4mfpvzab68KdlTkMgfi8e?usp=drive_link) to root

execute `sh setup_firebase.sh` in terminal

## iOS Setup

#### Requirements
* Android Studio
* XCode v.16.2 https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_16.2/Xcode_16.2.xip
* Simulator

#### Hyperverge Plugin Setup
* Step 1
```
Open Android Studio
    GoTo
    -> External Libraries 
    -> Flutter Plugins 
    -> hypersnapsdk_flutter-1.3.1 
    -> ios 
    -> hypersnapsdk_flutter.podspec 
    -> line 19 -> remove /DocsDetect (s.dependency 'HyperSnapSDK', '4.6.0')
```
* Step 2
```
Open Android Studio
    GoTo
    -> External Libraries 
    -> Flutter Plugins 
    -> hypersnapsdk_flutter-1.3.1 
    -> ios 
    -> Classes -> 
    FLHVDocsCapture.swift -> comment lines from 78 to 85
```
#### Commands
Checkout the repo, open terminal. Run the following commands:

* `cd ios`
* `rm -rf ~/Library/Caches/CocoaPods`
* `rm -rf ~/Library/Developer/Xcode/DerivedData/*`

  (if promted for y/n, press y and enter)
* `rm -rf Podfile.lock`
* `pod install --repo-update`

  Discard the changes in `watcher -> ios -> Podfile.lock`


## Run the App using Flavor Commands
Each environment has been configured using a package called [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr).

#### Before running the command, please select the proper device either in Android studio or in VS Code.

#### Use the following command to run the app in debug mode for both Android and iOS
```sh
flutter run -t lib/main-{env}.dart --flavor {env}
```

Replace the **_env_** with proper environment

* QA => **qa**
* Integration => **_integration_**
* UAT => **uat**
* DEV => **dev**
* Production => **_prod_**

#### Example : Run Privo in intergration Env in debug mode for both Android and iOS
```sh
flutter run -t lib/main-integration.dart --flavor integration
```

#### To run the app in release mode for both Android and iOS
```sh
flutter run —release -t lib/main-{env}.dart --flavor {env}
```

#### To build apk only for Android
```sh
flutter build apk -t lib/main-{env}.dart --flavor {env}
```

#### To build appBundle only for Android
```sh
flutter build appbundle -t lib/main-{env}.dart --flavor {env}
```

#### To build IPA file
```sh
flutter build ios -t lib/main-{env}.dart --flavor {env}
```


## Build APK Files
Run the script `generate_apk.sh` from the root of the repo.
This script will clean the project and generate the apk's with respective to the environment and it will pick the version number from `pubspec.lock` file, adding it to the apk's file name.

Before running the script please ensure that flutter SDK is properly installed in your system and
make sure that PATH is defined globally.

The script has the following parameters:

    - {env} (qa, integration, dev, uat, prod)
    - low_env
    - prod_bundle


* To build apk for each env seperately, add the respective flavor (`qa, integration, dev, uat, prod`)

e.g: `bash generate_apk.sh qa`
* Param `low_env` will build qa,int and uat apk files. This command will be usefull to share the apk's with the QA team and to update the apk's in gDrive.

`bash generate_apk.sh low_env`
* Param `prod_bundle` will build prod apk and bundle file, which can be sent to the Play Store for the release.

`bash generate_apk.sh prod_bundle`


The generate apk's can be found in a folder named **_privo-release-assets_** in project root
directory with all the required apk's.


## App Distribution
We are using **[Firebase App Distribution](https://firebase.google.com/docs/app-distribution "Firebase App Distribution")** to distribute app among intenal Testers and Developers.

##### Requirements
- Firebase CLI

##### Steps to install Firebase CLI
- Open the Terminal and execute the following command
  `curl -sL https://firebase.tools | bash`
- Once the Installation is done, login to firebase using the following command
  `firebase login`

##### Distribute App
Open Android Studio or VS Code, Open a terminal and execute

`sh app_dist.sh`

Please select the Proper **Platform**, **Environments**, **Release Notes** and **testing group**.


## State Management

This Project uses [GetX](https://pub.dev/packages/get) for Managing State, Routing and Dependency Injection.

