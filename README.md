# Qubit for Mobile app: iOS SDK
This SDK enables comprehensive event tracking and Qubit experience delivery from within an iOS app.

### Compatibility
This release is compatible with Xcode 12 & iOS14, and supports Swift & Objective-C.

### Privacy

This repository contains the privacy manifest, which details the data collected by the SDK:

| Data type               | What it's used for                       |
|-------------------------|------------------------------------------|
| **Device ID**           | Product personalization and analytics    |
| **Product Interaction** | Product personalization and analytics    |
| **Email Address**       | Product personalization and analytics    |
| **User ID**             | Product personalization and analytics    |
| **Coarse Location**     | Product personalization and analytics    |
| **Other Data Types**    | Analytics                                |

> **Note**
> 
> **Other Data Types** here represent `system version` and `system name` of the devices that use the SDK.

The SDK doesn't collect any sensitive data, such as payment information or passwords.
It only has access to the data that the app has access to.
This level of access is reflected in the `NSPrivacyAccessedAPITypeReasons` key via the `CA92.1` value.

Examine the file for more details: https://github.com/qubitdigital/qubit-sdk-ios/blob/master/QBTracker/QubitSDK/PrivacyInfo.xcprivacy

For more general information about privacy manifest files, see the Apple documentation: [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files).

### Getting started
To make use of this SDK, please contact your Qubit Customer Success representative.

### Getting help
Please contact support@qubit.com or raise an issue on GitHub.

# Releases

Further release notes are available in the [GitHub release notes](https://github.com/qubitdigital/qubit-sdk-ios/releases).

| VERSION | UPDATES |
|---|---|
| 2.0.8 | Fix regression in DeviceId creation that could lead to conflicts
| 2.0.7 | Update iOS Privacy Manifest with further best practice for geolocation
| 2.0.6 | Add iOS Privacy Manifest covering best practice use cases
| 2.0.5 | Improvements to event tracking - ensure viewNumber, sessionViewNumber and viewTs is accurately calculated
| 2.0.4 | Swift Package Manager is now supported for installation
| 2.0.3 | Bugs and performance fixes
| 2.0.1 | Introduction of functionality to reset the SDK using a custom device ID of your choice 
| 2.0.0 | Major release, bringing support for Placement API. Upgrade to 2.* to use this feature.
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
| 1 | Swift Package Manager | Swift | GitHub |
| 2 | CocoaPods | Swift & Objective-C | CocoaPods.org & GitHub |
| 3 | XCFramework | Swift & Objective-C | GitHub |

Further details on installation options are below.

## (1) Swift Package Manager

To integrate QubitSDK into your Xcode project using Swift Package Manager:

* File > Swift Packages > Add Package Dependency
* Add `https://github.com/qubitdigital/qubit-sdk-ios.git`
* Select *Up to Next Major* with `2.0.4`
* In your target's *Build Phases* add *QubitSDK* to *Target Dependencies* and *Link Binary With Libraries*

Or add to another package as a dependency:

```
dependencies: [
    .package(url: "https://github.com/qubitdigital/qubit-sdk-ios.git", .upToNextMajor(from: "2.0.4"))
]
```

## (2) CocoaPods
CocoaPods is a dependency management system for iOS. If you do not have CocoaPods configured, please read the installation documents on their website (https://guides.cocoapods.org/using/getting-started.html). If you use another dependency management system, please contact us for alternative options.

If you do not wish to implement CocoaPods, check out the "Using Framework Files" section below.

### Install the QubitSDK package

Releases of this SDK are found on CocoaPods here: https://cocoapods.org/pods/QubitSDK.

Update the following into your Podfile:

```
target 'MyApp' do
  pod 'QubitSDK', '~> 2.0.4'
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
    "https://github.com/qubitdigital/qubit-sdk-ios.git", :tag => "2.0.4"
end
```

Specify a GitHub *tag* to ensure you only opt-in to new releases of this SDK.

If you access the repo via SSH as opposed to HTTPS, the target URL will be *git@github.com:qubitdigital/qubit-sdk-ios.git*.

Then, from your command line, run

```
pod install
```

If you encounter permission issues, ensure the GitHub username step has been successfully completed. Please consult the cocoapods documentation if you have any other issues with this step. If your process freezes on “Analysing dependencies”, try running *pod repo remove master*, *pod setup*, then *pod install* again.

## (3) Integrate using a framework

If you wish to use QubitSDK without a package manager such as SPM or CocoaPods, take a look at [our framework options](README-frameworks.md).

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
    [QubitSDK startWithTrackingId: @"XXXXX" logLevel: QBLogLevelDisabled queuePriority: QBQueuePriorityBackground];
    return YES;
}
```

### Swift

```swift
import QubitSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    QubitSDK.start(withTrackingId: "XXXXX", logLevel: .disabled, queuePriority: .background)
    return true
}
```

Here *XXXXX* is your Qubit Tracking ID, which is a unique string representing your account, and will have already been provided to you.

To get `trackingId` and `deviceId`, you can refer to the corresponding properties of the imported library:

```objective-c
NSLog([QubitSDK trackingId]);
NSLog([QubitSDK deviceId]);
```

```swift
print(QubitSDK.trackingId)
print(QubitSDK.deviceId)
```

If you need to change the `deviceId`, you need to restart the SDK with a new ID:

```objective-c
NSString *newDeviceID = @"YourNewDeviceID";
[QubitSDK restartWithCustomDeviceID:newDeviceID];
```

```swift
let newDeviceID = "yourNewDeviceID"
QubitSDK.restartWithCustomDeviceID(id: newDeviceID)
```

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
Use `fetchExperiences()` to integrate Experiences into your app.

Swift
```swift
// Fetch an experience by ID (143640 in this example)
QubitSDK.fetchExperiences(withIds: [143640], onSuccess: { (experiences) in
    if let exp = experiences.first {

        // list out the payload key/values
        print("Got experience - payload:")
        for (key, value) in exp.payload {
            print("\(key) -> \(value)")
        }
        // mark the experience as shown
        exp.shown()
    }
}, 
onError: { (error) in
    print("Got error: \(error.localizedDescription)")
}, 
preview: false, ignoreSegments: false, variation: nil)
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

Above call takes optional parameters such as  `preview`, `ignoreSegments` and `variation`.

# Placements
Use `getPlacement()` to add Qubit Placements into your app.

Swift
```swift
QubitSDK.getPlacement(withId: "83f6b528-9336-11eb-a8b3", onSuccess: { (placement) in
    if let placement = placement {

        // fetch our content payload
        print("Got placement - content:")
        print("placement content -> \(placement.content)")

        // send an impression event
        placement.impression()

        // send a clickthrough event
        placement.clickthrough()
    }
}, onError: { (error) in
    print("Got error: \(error.localizedDescription)")
})

```

Objective-C
```objective-c
[QubitSDK getPlacementWithId:@"123456" onSuccess:^(QBPlacementEntity *> * _Nonnull placement) {
    [placement clickthrough];
    [placement impression];
} onError:^(NSError * _Nonnull error) {
    NSLog(@"%@", error.description);
};
```

Please contact your Qubit customer success team for more on this feature.

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
