# Qubit for Mobile app: iOS SDK
This SDK enables comprehensive event tracking and Qubit experience delivery from within an iOS app.

### Compatibility
This release is compatible with Xcode 12 & iOS14, and supports Swift & Objective-C.

### Getting started
To make use of this SDK, please contact your Qubit Customer Success representative.

### Getting help
Please contact support@qubit.com or raise an issue on GitHub.

# Releases

Further release notes are available in the [GitHub release notes](https://github.com/qubitdigital/qubit-sdk-ios/releases).

| VERSION | UPDATES |
|---|---|
| 2.0.0 | Major release, bringing support for Placement API.
| 1.0.16 | Fixed regression where a percentage of events were incorrectly serialized to JSON.
| 1.0.15 | Removed global exception handling. QuibitSDK.xcframework released.
| 1.0.11 | Removed QuibitSDK.xcframework due to ongoing Xcode12 bug. UniversalFramework released.
| 1.0.10 | Bug fixes for Objective-C and Swift. New QuibitSDK.xcframework released.
| 1.0.9 | Updated framework files to support iOS 14
| 1.0.8 | Updated framework files
| 1.0.7 | Upgrades to support React Native SDK
| 1.0.6 | SWIFT_VERSION support for pod installations
| 1.0.4 | Added possibility of temporary disabling and enabling tracker.
| 1.0.3 | Updated framework for Swift 5. |
| 1.0.2 | Fixed issue where Boolean values inside events were lost. Fixed various iOS warnings. Prevented log writing in _HandleException_ if loglevel=disabled |
| 1.0.0 | V1 Release including Native Experiences


# Integration

## Integration options

| | Method | Supports | Host |
|---|---|---|---|
| 1 | CocoaPods | Swift & Objective-C | CocoaPods.org & GitHub |
| 2 | XCFramework | Swift & Objective-C | GitHub |




Further details on installation options are below.


## (1) CocoaPods
CocoaPods is a dependency management system for iOS. If you do not have CocoaPods configured, please read the installation documents on their website (https://guides.cocoapods.org/using/getting-started.html). If you use another dependency management system, please contact us for alternative options.

If you do not wish to implement CocoaPods, check out the "Using Framework Files" section below.

### Install the QubitSDK package

Releases of this SDK are found on CocoaPods here: https://cocoapods.org/pods/QubitSDK.

Update the following into your Podfile:

```
target 'MyApp' do
  pod 'QubitSDK', '~> 1.0.15'
end
```

Then run a pod install inside your terminal, or from CocoaPods.app.

Alternatively to give it a test run, run the command:

`pod try QubitSDK`


### Alternatively, install from GitHub

Once you have CocoaPods installed, navigate to the Podfile in your app’s root directory. In the file, add the lines:

```
use_frameworks!

target 'MyApp' do
    pod "QubitSDK", :git =>
    "https://github.com/qubitdigital/qubit-sdk-ios.git", :tag => "1.0.15"
end
```

Specify a GitHub *tag* to ensure you only opt-in to new releases of this SDK.

If you access the repo via SSH as opposed to HTTPS, the target URL will be *git@github.com:qubitdigital/qubit-sdk-ios.git*.

Then, from your command line, run

```
pod install
```

If you encounter permission issues, ensure the GitHub username step has been successfully completed. Please consult the cocoapods documentation if you have any other issues with this step. If your process freezes on “Analysing dependencies”, try running *pod repo remove master*, *pod setup*, then *pod install* again.

## (2) Integrate using a framework

### QubitSDK.xcframework
If you wish to use QubitSDK without a package manager such as CocoaPods, you can do so by importing the `XCFrameworkRelease/QubitSDK.xcframework` files into your project. This enables both debugging in the simulator and executing code on the iOS platform.

To add QubitSDK to your project using this method,
just clone this GitHub repo and then:

1. Open Xcode, and right-click on your project.
2. Select "Add Files to <Your Project Name>". Select `XCFrameworkRelease/QubitSDK.xcframework` and press Add, with 'Copy items as needed' ticked.
3. In `Project Settings > General`, ensure `QubitSDK.xcframework` is embedded into your project.
4. The SDK will now be available for use.


### UniversalFramework
If, for any reason, you don't wish to use the provided methods for integrating the SDK, you can still use the legacy method of integrating frameworks - UniversalFramework.

This method is a little more challenging as it requires you to strip unused architectures during compilation. Note that this will be deprecated in a future release.

1. Open Xcode, and right-click on your project.
2. Select "Add Files to <Your Project Name>". Select `UniversalFramework/QubitSDK.framework` and press Add, with 'Copy items as needed' ticked.
3. In `Project Settings > General`, ensure `QubitSDK.framework` is set as DO NOT EMBED.
4. The SDK will now be available for use.
5. In `Project Settings > Build Phases` add new `Run Script` phase.
6. Put in the following script:

```bash
FRAMEWORK_APP_PATH="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
# 1. Copying FRAMEWORK to FRAMEWORK_APP_PATH
find "$SRCROOT" -name '*.framework' -type d | while read -r FRAMEWORK
do
if [[ $FRAMEWORK == *"QubitSDK.framework" ]]
then
    echo "Copying $FRAMEWORK into $FRAMEWORK_APP_PATH"
    cp -r $FRAMEWORK "$FRAMEWORK_APP_PATH"
fi
done
# 2. Loops through the frameworks embedded in the application and removes unused architectures.
find "$FRAMEWORK_APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
if [[ $FRAMEWORK == *"QubitSDK.framework" ]]
then

    echo "Strip framework: $FRAMEWORK"
    FRAMEWORK_EXECUTABLE_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleExecutable" "$FRAMEWORK/Info.plist")
    FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
    echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"
    EXTRACTED_ARCHS=()
    for ARCH in $ARCHS
    do
    echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
    lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
    EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
    done
    echo "Merging extracted architectures: ${ARCHS}"
    lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
    rm "${EXTRACTED_ARCHS[@]}"
    echo "Replacing original executable with thinned version"
    rm "$FRAMEWORK_EXECUTABLE_PATH"
    mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"
    codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS:-} --preserve-metadata=identifier,entitlements $FRAMEWORK_EXECUTABLE_PATH
else
    echo "Ignored strip on: $FRAMEWORK"
fi
done
```
7. The SDK will now be available for use.

#### Using UniversalFramework with Objective-C

With Xcode 12, you may experience issues building your app for testing in the iOS simulator. You may need to to add `arm64` to `excluded_architectures` in the Build Settings of your target app. If you wish to test on device, remove `arm64` from excluded architectures.

This step is not necessary for Swift.

## Starting the QubitSDK
Starting the QubitSDK with a tracking ID will allow us to correctly identify your data.  
When starting the SDK, you can specify the log level of the SDK.  This will determine the amount of logging the SDK will produce.
The log level options for Objective-C are: QBLogLevelDisabled, QBLogLevelError, QBLogLevelInfo, QBLogLevelDebug, QBLogLevelVerbose, QBLogLevelWarning
The log level options for Swift are: .disabled, .error, .info, .debug, .verbose, .warning

To start the QubitSDK (preferably in your AppDelegate didFinishLaunchingWithOptions) use the following method

### Objective-C

CocoaPods:
```objective-c
@import QubitSDK;
```

Framework:
```objective-c
#import "QubitSDK/QubitSDK.h"
```

Launch:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [QubitSDK startWithTrackingId: @"XXXXX" logLevel: QBLogLevelDisabled];
    return YES;
}
```

### Swift

```swift
import QubitSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    QubitSDK.start(withTrackingId: "XXXXX", logLevel: .disabled)
    return true
}
```

Here *XXXXX* is your Qubit Tracking ID, which is a unique string representing your account, and will have already been provided to you. If you haven’t received a tracking ID, or don’t know what yours is, please contact us.

# Sending Events

Before you will be able to send events from inside the app, a config file will need to be generated by Qubit on S3.
Here are the settings that can be set in the config:

```javascript
- tracking_id
- endpoint
- configuration_reload_interval
- queue_timeout
- send_auto_view_events
- send_auto_interaction_events
- send_geo_data
- vertical
- property_id
- namespace
- disabled
```

To send an event, call the *sendEvent* method. The following example emits a “ecUser” event:

```objective-c
#import "QubitSDK/QubitSDK.h"

[QubitSDK sendEventWithType:@"ecUser" dictionary:userDictionary];
[QubitSDK sendEventWithType:@"ecUser" data:userJsonAsString];
```

```swift
import QubitSDK

QubitSDK.sendEvent(type: "ecUser", dictionary: userDictionary)
QubitSDK.sendEvent(type: "ecUser", data: userJsonAsString)
```

where userDictionary is of type NSDictionary in Objective-C, Dictionary in Swift, and takes the form:

```
{
  userId: "jsmith",
  currency: "USD",
  email: "jsmith@gmail.com",
  firstName: "John",
  firstSession: false,
  gender: "Mr",
  hasTransacted: true,
  lastName: "Smith",
  language: "en-gb",
  title: "Mr",
  username: "jsmith"
}
```

# Experiences
SDK contains methods to fetch Experiences. This can be achieved by:

Swift
```swift
// Fetch an experience by ID (143640 in this example)
// This is calling for live experiences only
QubitSDK.fetchExperiences(withIds: [143640], onSuccess: { (experiences) in
    if let exp = experiences.first {
        // list out the payload values
        print("Got experience - payload:")
        for (key, value) in exp.payload {
            print("\(key) -> \(value)")
        }
        // mark the experience as shown
        exp.shown()
    }
}, onError: { (error) in
    print("Got error: \(error.localizedDescription)")
}, preview: false, ignoreSegments: false, variation: nil)
```

Objective-C
```objective-c
[QubitSDK fetchExperiencesWithIds:@[@1] onSuccess:^(NSArray<QBExperienceEntity *> * _Nonnull experiences) {
    // select the first experience returned
    QBExperienceEntity* firstEntity = experiences.firstObject;

    // make a POST call to the returned callback URL
    [firstEntity shown];
} onError:^(NSError * _Nonnull error) {
    NSLog(@"%@", error.description);
} preview:false variation:false ignoreSegments:false];
```

Above call takes optional parameters like `preview`, `ignoreSegments` and `variation`.

# Disabling Tracking
If you would like to disable tracking, use the following method.

```objective-c
#import "QubitSDK/QubitSDK.h"

[QubitSDK stopTracking];   
```

```swift
import QubitSDK

QubitSDK.stopTracking()
```

# Common Crypto Issue
If you notice "Missing required module 'CommonCrypto'" then please run in the terminal:

```
xcode-select --install
```

After installation, build your project again.
