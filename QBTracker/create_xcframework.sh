
# set framework folder name
FRAMEWORK_FOLDER_NAME="QubitSDK_XCFramework"
# set framework name or read it from project by this variable
FRAMEWORK_NAME="QubitSDK"
#xcframework path
FRAMEWORK_PATH="../XCFrameworkRelease/${FRAMEWORK_NAME}.xcframework"
# set path for iOS simulator archive
SIMULATOR_ARCHIVE_PATH="${FRAMEWORK_FOLDER_NAME}/simulator.xcarchive"
# set path for iOS device archive
IOS_DEVICE_ARCHIVE_PATH="${FRAMEWORK_FOLDER_NAME}/iOS.xcarchive"

rm -rf "${FRAMEWORK_FOLDER_NAME}"
rm -rf "${FRAMEWORK_PATH}"
echo "Deleted ${FRAMEWORK_FOLDER_NAME}"

echo "Archiving simulator & device"
echo "Simulator archive path ${SIMULATOR_ARCHIVE_PATH}"
echo "Device archive path ${IOS_DEVICE_ARCHIVE_PATH}"

echo "Creating folder ${FRAMEWORK_FOLDER_NAME}"
mkdir "${FRAMEWORK_FOLDER_NAME}"
echo "Created ${FRAMEWORK_FOLDER_NAME}"
echo "Archiving SIMULATOR -----------------"
xcodebuild archive -scheme ${FRAMEWORK_NAME} -destination="iOS Simulator" -archivePath "${SIMULATOR_ARCHIVE_PATH}" -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


echo "Archiving DEVICE -------------------"
xcodebuild archive -scheme ${FRAMEWORK_NAME} -destination="iOS" -archivePath "${IOS_DEVICE_ARCHIVE_PATH}" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

#Creating XCFramework
echo "${ROW_STRING}"
echo "Creating XCFramework ----------------"
echo "${ROW_STRING}"
xcodebuild -create-xcframework -framework ${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -framework ${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -output "${FRAMEWORK_PATH}"

rm -rf "${SIMULATOR_ARCHIVE_PATH}"
rm -rf "${IOS_DEVICE_ARCHIVE_PATH}"

