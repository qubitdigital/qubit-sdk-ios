# Qubit Mobile
Installation of the QubitSDK, to provide event tracking and lookup. To make use of this SDK, please contact your Qubit Customer Success representative.

# Updates


| VERSION | UPDATES |
|---|---|
| 1.0.10 | Bug fixes for Objective-C and Swift. New QuibitSDK.xcframework released.
| 1.0.9 | Updated framework files to support iOS 14
| 1.0.8 | Updated framework files
| 1.0.7 | Upgrades to support React Native SDK
| 1.0.6 | SWIFT_VERSION support for pod installations
| 1.0.4 | Added possibility of temporary disabling and enabling tracker.
| 1.0.3 | Updated framework for Swift 5. |
| 1.0.2 | Fixed issue where Boolean values inside events were lost. Fixed various iOS warnings. Prevented log writing in _HandleException_ if loglevel=disabled |
| 1.0.0 | V1 Release including Native Experiences
| 0.3.14 | Fixed accessing experience entity properties
| 0.3.13 | Fixed issue with serializing nested dictionaries in Events
| 0.3.12 | Experiences added to the SDK
| 0.3.11 | Fix for serializing decimals in JSON
| 0.3.10 | Added trackerID and deviceID to the QubitSDK
| 0.3.9 | Xcode 10 supported, Fix loop cycle for sending events
| 0.3.8 | Fix JSONSerialization for boolean values
| 0.3.7 | Fixes
| 0.3.6 | CoreData updated
| 0.3.5 | JSONSerialization fixed in value precisions for
| 0.3.4 | Fix issue with sending events
| 0.3.3 | Fix crash for old devices with 32-bit architecture
| 0.3.2 | Fix Common Crypto issues
| 0.3.1 | Update to use Swift 4.0.3
| 0.3.0 | Update to use Swift 4.0
| 0.2.7 | Update to resolve potential reachability memory leak issues |
| 0.2.6 | Removal of unused code with regards to automatic event generation and segment membership requests|
| 0.2.5 | Update swizzling functionality|
| 0.2.4 | Update that fixes some scenarios that used this SDK in Swift |
| 0.2.3 | Update segmentation functionality |
| 0.2.2 | Update to use initWithData |


# Installation

## Cocoa Pods
Cocoa pods are a dependency management system for iOS. If you do not have cocoa pods configured, please read the installation documents on their website (https://guides.cocoapods.org/using/getting-started.html). If you use another dependency management system, please contact us for alternative options. If you do not wish to implement one, please read "Using Framework Files" section.

Once you have cocoa pods installed, navigate to the Podfile in your app’s root directory. In the file, add the lines:

```
use_frameworks!

target :XXXXX do
    pod "QubitSDK", :git =>
    "https://github.com/qubitdigital/qubit-sdk-ios.git", :tag => "1.0.4"
end
```

where *XXXXX* is the name of your app target. Specify a GitHub *tag* to ensure you only opt-in to new releases of this SDK.

If you access the repo via SSH as opposed to HTTPS, the target URL will be *git@github.com:qubitdigital/qubit-sdk-ios.git*. Then, from your command line, run

```
pod install
```

If you encounter permission issues, ensure the GitHub username step has been successfully completed. Please consult the cocoapods documentation if you have any other issues with this step. If your process freezes on “Analysing dependencies”, try running *pod repo remove master*, *pod setup*, then *pod install* again.

## Deploying without CocoaPods - using a framework

**Recommended approach**

If you wish to use QubitSDK without a package manager such as CocoaPods, you can do so by importing the `QubitSDK.xcframework` framework files to your project. This enables both debugging in the simulator and executing code on the iOS platform.

To add QubitSDK to your project, open Xcode, and right-click on your project. Select "Add Files to <Your Project Name>". Select framework and press Add. The SDK will be added and linked to your project. 


**Legacy framework files - to be deprecated in a future release**

We prepared two versions of the framework for each configuration build - debug and release. FrameworkDebug contains files needed to run the SDK on devices and simulators (arm64, arm7, i384, and x86_64 architectures). FrameworkRelease contains files only for device architectures (arm, arm7, arm64). Please refer to our two example projects - QubitSwiftFrameworkDebugExampleApp and QubitSwiftFrameworkReleaseExampleApp. 


## Starting the QubitSDK
Starting the QubitSDK with a tracking ID will allow us to correctly identify your data.  
When starting the SDK, you can specify the log level of the SDK.  This will determine the amount of logging the SDK will produce.
The log level options for Objective-C are: QBLogLevelDisabled, QBLogLevelError, QBLogLevelInfo, QBLogLevelDebug, QBLogLevelVerbose, QBLogLevelWarning
The log level options for Swift are: .disabled, .error, .info, .debug, .verbose, .warning

To start the QubitSDK (preferably in your AppDelegate didFinishLaunchingWithOptions) use the following method


```objective-c
#import "QubitSDK/QubitSDK.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [QubitSDK startWithTrackingId: @"XXXXX" logLevel: QBLogLevelDisabled];
    return YES;
}
```

```swift
import QubitSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    QubitSDK.start(withTrackingId: "XXXXX", logLevel: .disabled)
    return true
}
```

Here *XXXXX* is your Qubit Tracking ID, which is a unique string representing your account, and will have already been provided to you. If you haven’t received a tracking ID, or don’t know what yours is, please contact us.
Objective-C requires *QubitSDK/QubitSDK.h* to be declared as an import within the file.
Swift requires QubitSDK to be declared as an import within the file.

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
    QBExperienceEntity* firstEntity = experiences.firstObject;
    [firstEntity shown]; // make a POST call to the returned callback URL
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
if add QubitSDK and still have problem with "Missing required module 'CommonCrypto'" please run in terminal:

```
xcode-select --install
```
after installation please build project again
