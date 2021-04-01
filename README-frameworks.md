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