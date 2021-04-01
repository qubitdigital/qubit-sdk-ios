#if 0
#elif defined(__arm64__) && __arm64__
// Generated by Apple Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)
#ifndef QUBITSDK_SWIFT_H
#define QUBITSDK_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreData;
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="QubitSDK",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class NSEntityDescription;
@class NSManagedObjectContext;

SWIFT_CLASS("_TtC8QubitSDK14QBContextEvent")
@interface QBContextEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC8QubitSDK7QBEvent")
@interface QBEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@class NSCoder;

SWIFT_CLASS("_TtC8QubitSDK18QBExperienceEntity")
@interface QBExperienceEntity : NSObject <NSCoding>
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> * _Nonnull payload;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


@interface QBExperienceEntity (SWIFT_EXTENSION(QubitSDK))
- (void)shown;
@end


SWIFT_CLASS("_TtC8QubitSDK26QBExperienceEntityCallback")
@interface QBExperienceEntityCallback : NSObject
- (void)shown;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC8QubitSDK11QBLastEvent")
@interface QBLastEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


typedef SWIFT_ENUM(NSInteger, QBLogLevel, open) {
  QBLogLevelDisabled = 0,
  QBLogLevelError = 1,
  QBLogLevelInfo = 2,
  QBLogLevelDebug = 3,
  QBLogLevelVerbose = 4,
  QBLogLevelWarning = 5,
};


SWIFT_CLASS("_TtC8QubitSDK14QBLookupEntity")
@interface QBLookupEntity : NSObject
@end


SWIFT_CLASS("_TtC8QubitSDK11QBMetaEvent")
@interface QBMetaEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC8QubitSDK17QBPlacementEntity")
@interface QBPlacementEntity : NSObject <NSCoding>
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable Content;
- (void)encodeWithCoder:(NSCoder * _Nonnull)coder;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)clickthrough;
- (void)impression;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC8QubitSDK14QBSessionEvent")
@interface QBSessionEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC8QubitSDK13QBTrackerInit")
@interface QBTrackerInit : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8QubitSDK16QBTrackerManager")
@interface QBTrackerManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) QBTrackerManager * _Nonnull sharedManager SWIFT_DEPRECATED_MSG("will be removed in next version");)
+ (QBTrackerManager * _Nonnull)sharedManager SWIFT_WARN_UNUSED_RESULT;
- (void)setTrackingId:(NSString * _Nonnull)trackingId SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK, please use [QubitSDK startWithTrackingId:logLevel:]/QubitSDK.start(withTrackingId)");
- (void)setDebugEndpoint:(NSString * _Nonnull)endPointUrl SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)unsubscribeToTracking SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK, please use [QubitSDK stopTracking]/QubitSDK.stopTracking()");
- (void)subscribeToTracking SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK, please use [QubitSDK startWithTrackingId:logLevel:]/QubitSDK.start(withTrackingId)");
- (void)dispatchEvent:(NSString * _Nonnull)type withData:(NSDictionary<NSString *, id> * _Nonnull)withData SWIFT_DEPRECATED_MSG("will be removed in next version of SDK, please use [QubitSDK sendEventWithType:dictionary:]/QubitSDK.sendEvent(type,dictionary)");
- (void)dispatchEvent:(NSString * _Nonnull)type withStringData:(NSString * _Nonnull)withStringData SWIFT_DEPRECATED_MSG("will be removed in next version of SDK, please use [QubitSDK sendEventWithType:data:]/QubitSDK.sendEvent(type,data)");
- (void)dispatchSessionEvent:(NSTimeInterval)startTimeStamp withEnd:(NSTimeInterval)withEnd SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (NSString * _Nonnull)getUserID SWIFT_WARN_UNUSED_RESULT SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)setStashInfo:(NSString * _Nonnull)data key:(NSString * _Nonnull)key withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)setStashInfo:(NSString * _Nonnull)key withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger, NSString * _Nonnull))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)setStashInfoMultiple:(NSArray<NSString *> * _Nonnull)userkeys withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger, NSDictionary<NSString *, id> * _Nonnull))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)getSegmentMembershipInfo:(NSString * _Nonnull)userId withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger, NSArray<NSString *> * _Nonnull))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;

SWIFT_CLASS("_TtC8QubitSDK8QubitSDK")
@interface QubitSDK : NSObject
/// Start the QubitSDK
/// \param id trackingId
///
/// \param logLevel QBLogLevel, default = .disabled
///
+ (void)startWithTrackingId:(NSString * _Nonnull)id logLevel:(enum QBLogLevel)logLevel;
/// Pauses or resumes event tracking
/// <ul>
///   <li>
///     Parameters:
///   </li>
///   <li>
///     enable: default: enabled
///   </li>
/// </ul>
+ (void)enable:(BOOL)enable;
/// Send and event
/// \param type eventType
///
/// \param data JSONString of event data
///
+ (void)sendEventWithType:(NSString * _Nonnull)type data:(NSString * _Nonnull)data;
/// Send and event
/// \param type eventType
///
/// \param dictionary event representing by dictionary
///
+ (void)sendEventWithType:(NSString * _Nonnull)type dictionary:(NSDictionary<NSString *, id> * _Nonnull)dictionary;
/// Send and event
/// \param type eventType
///
/// \param event QBEventEntity
///
+ (void)sendEventWithEvent:(id _Nullable)event;
/// Create event
/// \param type eventType
///
/// \param data json String
///
+ (id _Nullable)createEventWithType:(NSString * _Nonnull)type data:(NSString * _Nonnull)data SWIFT_WARN_UNUSED_RESULT;
/// Create event
/// \param type eventType
///
/// \param event QBEventEntity
///
+ (id _Nullable)createEventWithType:(NSString * _Nonnull)type dictionary:(NSDictionary<NSString *, id> * _Nonnull)dictionary SWIFT_WARN_UNUSED_RESULT;
/// Stop tracking
+ (void)stopTracking;
/// Fetch experiences
/// \param ids experience ids to filter. When empty list, all experiences will be returned.
///
/// \param onSuccess callback when the download succeeds
///
/// \param onError callback when the download fails
///
/// \param preview when ‘true’, the latest unpublished interation of experience is used
///
/// \param ignoreSegments when ‘true’, the payloads for all of the experiences will be returned
///
/// \param variation variation of experience to return
///
+ (void)fetchExperiencesWithIds:(NSArray<NSNumber *> * _Nonnull)ids onSuccess:(void (^ _Nonnull)(NSArray<QBExperienceEntity *> * _Nonnull))onSuccess onError:(void (^ _Nonnull)(NSError * _Nonnull))onError preview:(BOOL)preview variation:(BOOL)ignoreSegments ignoreSegments:(NSNumber * _Nullable)variation;
/// Fetch placement
/// \param mode The mode to fetch placements content with, can be one of .live, .sample, .preview
///
/// \param placementId The unique ID of the placement
///
/// \param attributes placement attributes
///
/// \param campaignId Unique ID of the campaign to preview. Passing this will fetch placements data for campaign preview
///
/// \param experienceId Unique ID of the experience to preview. Passing this will fetch placements data for experience preview. This must be used in conjunction with campaignIds
///
/// \param onSuccess callback when the download succeeds
///
/// \param onError callback when the download fails
///
+ (void)getPlacementWithId:(NSString * _Nonnull)id mode:(NSString * _Nullable)mode attributes:(NSString * _Nullable)attributes campaignId:(NSString * _Nullable)campaignId experienceId:(NSString * _Nullable)experienceId onSuccess:(void (^ _Nonnull)(QBPlacementEntity * _Nonnull))onSuccess onError:(void (^ _Nonnull)(NSError * _Nonnull))onError;
/// Fetch current lookup entity,
///
/// returns:
/// nil if there is no lookup yet, entity otherwise
+ (QBLookupEntity * _Nullable)getLookupData SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#elif defined(__ARM_ARCH_7A__) && __ARM_ARCH_7A__
// Generated by Apple Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)
#ifndef QUBITSDK_SWIFT_H
#define QUBITSDK_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreData;
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="QubitSDK",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class NSEntityDescription;
@class NSManagedObjectContext;

SWIFT_CLASS("_TtC8QubitSDK14QBContextEvent")
@interface QBContextEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC8QubitSDK7QBEvent")
@interface QBEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@class NSCoder;

SWIFT_CLASS("_TtC8QubitSDK18QBExperienceEntity")
@interface QBExperienceEntity : NSObject <NSCoding>
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> * _Nonnull payload;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


@interface QBExperienceEntity (SWIFT_EXTENSION(QubitSDK))
- (void)shown;
@end


SWIFT_CLASS("_TtC8QubitSDK26QBExperienceEntityCallback")
@interface QBExperienceEntityCallback : NSObject
- (void)shown;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC8QubitSDK11QBLastEvent")
@interface QBLastEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


typedef SWIFT_ENUM(NSInteger, QBLogLevel, open) {
  QBLogLevelDisabled = 0,
  QBLogLevelError = 1,
  QBLogLevelInfo = 2,
  QBLogLevelDebug = 3,
  QBLogLevelVerbose = 4,
  QBLogLevelWarning = 5,
};


SWIFT_CLASS("_TtC8QubitSDK14QBLookupEntity")
@interface QBLookupEntity : NSObject
@end


SWIFT_CLASS("_TtC8QubitSDK11QBMetaEvent")
@interface QBMetaEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC8QubitSDK17QBPlacementEntity")
@interface QBPlacementEntity : NSObject <NSCoding>
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable Content;
- (void)encodeWithCoder:(NSCoder * _Nonnull)coder;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)clickthrough;
- (void)impression;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC8QubitSDK14QBSessionEvent")
@interface QBSessionEvent : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC8QubitSDK13QBTrackerInit")
@interface QBTrackerInit : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8QubitSDK16QBTrackerManager")
@interface QBTrackerManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) QBTrackerManager * _Nonnull sharedManager SWIFT_DEPRECATED_MSG("will be removed in next version");)
+ (QBTrackerManager * _Nonnull)sharedManager SWIFT_WARN_UNUSED_RESULT;
- (void)setTrackingId:(NSString * _Nonnull)trackingId SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK, please use [QubitSDK startWithTrackingId:logLevel:]/QubitSDK.start(withTrackingId)");
- (void)setDebugEndpoint:(NSString * _Nonnull)endPointUrl SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)unsubscribeToTracking SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK, please use [QubitSDK stopTracking]/QubitSDK.stopTracking()");
- (void)subscribeToTracking SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK, please use [QubitSDK startWithTrackingId:logLevel:]/QubitSDK.start(withTrackingId)");
- (void)dispatchEvent:(NSString * _Nonnull)type withData:(NSDictionary<NSString *, id> * _Nonnull)withData SWIFT_DEPRECATED_MSG("will be removed in next version of SDK, please use [QubitSDK sendEventWithType:dictionary:]/QubitSDK.sendEvent(type,dictionary)");
- (void)dispatchEvent:(NSString * _Nonnull)type withStringData:(NSString * _Nonnull)withStringData SWIFT_DEPRECATED_MSG("will be removed in next version of SDK, please use [QubitSDK sendEventWithType:data:]/QubitSDK.sendEvent(type,data)");
- (void)dispatchSessionEvent:(NSTimeInterval)startTimeStamp withEnd:(NSTimeInterval)withEnd SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (NSString * _Nonnull)getUserID SWIFT_WARN_UNUSED_RESULT SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)setStashInfo:(NSString * _Nonnull)data key:(NSString * _Nonnull)key withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)setStashInfo:(NSString * _Nonnull)key withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger, NSString * _Nonnull))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)setStashInfoMultiple:(NSArray<NSString *> * _Nonnull)userkeys withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger, NSDictionary<NSString *, id> * _Nonnull))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (void)getSegmentMembershipInfo:(NSString * _Nonnull)userId withCallback:(SWIFT_NOESCAPE void (^ _Nonnull)(NSInteger, NSArray<NSString *> * _Nonnull))withCallback SWIFT_UNAVAILABLE_MSG("this method is unavailable at new version of SDK");
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;

SWIFT_CLASS("_TtC8QubitSDK8QubitSDK")
@interface QubitSDK : NSObject
/// Start the QubitSDK
/// \param id trackingId
///
/// \param logLevel QBLogLevel, default = .disabled
///
+ (void)startWithTrackingId:(NSString * _Nonnull)id logLevel:(enum QBLogLevel)logLevel;
/// Pauses or resumes event tracking
/// <ul>
///   <li>
///     Parameters:
///   </li>
///   <li>
///     enable: default: enabled
///   </li>
/// </ul>
+ (void)enable:(BOOL)enable;
/// Send and event
/// \param type eventType
///
/// \param data JSONString of event data
///
+ (void)sendEventWithType:(NSString * _Nonnull)type data:(NSString * _Nonnull)data;
/// Send and event
/// \param type eventType
///
/// \param dictionary event representing by dictionary
///
+ (void)sendEventWithType:(NSString * _Nonnull)type dictionary:(NSDictionary<NSString *, id> * _Nonnull)dictionary;
/// Send and event
/// \param type eventType
///
/// \param event QBEventEntity
///
+ (void)sendEventWithEvent:(id _Nullable)event;
/// Create event
/// \param type eventType
///
/// \param data json String
///
+ (id _Nullable)createEventWithType:(NSString * _Nonnull)type data:(NSString * _Nonnull)data SWIFT_WARN_UNUSED_RESULT;
/// Create event
/// \param type eventType
///
/// \param event QBEventEntity
///
+ (id _Nullable)createEventWithType:(NSString * _Nonnull)type dictionary:(NSDictionary<NSString *, id> * _Nonnull)dictionary SWIFT_WARN_UNUSED_RESULT;
/// Stop tracking
+ (void)stopTracking;
/// Fetch experiences
/// \param ids experience ids to filter. When empty list, all experiences will be returned.
///
/// \param onSuccess callback when the download succeeds
///
/// \param onError callback when the download fails
///
/// \param preview when ‘true’, the latest unpublished interation of experience is used
///
/// \param ignoreSegments when ‘true’, the payloads for all of the experiences will be returned
///
/// \param variation variation of experience to return
///
+ (void)fetchExperiencesWithIds:(NSArray<NSNumber *> * _Nonnull)ids onSuccess:(void (^ _Nonnull)(NSArray<QBExperienceEntity *> * _Nonnull))onSuccess onError:(void (^ _Nonnull)(NSError * _Nonnull))onError preview:(BOOL)preview variation:(BOOL)ignoreSegments ignoreSegments:(NSNumber * _Nullable)variation;
/// Fetch placement
/// \param mode The mode to fetch placements content with, can be one of .live, .sample, .preview
///
/// \param placementId The unique ID of the placement
///
/// \param attributes placement attributes
///
/// \param campaignId Unique ID of the campaign to preview. Passing this will fetch placements data for campaign preview
///
/// \param experienceId Unique ID of the experience to preview. Passing this will fetch placements data for experience preview. This must be used in conjunction with campaignIds
///
/// \param onSuccess callback when the download succeeds
///
/// \param onError callback when the download fails
///
+ (void)getPlacementWithId:(NSString * _Nonnull)id mode:(NSString * _Nullable)mode attributes:(NSString * _Nullable)attributes campaignId:(NSString * _Nullable)campaignId experienceId:(NSString * _Nullable)experienceId onSuccess:(void (^ _Nonnull)(QBPlacementEntity * _Nonnull))onSuccess onError:(void (^ _Nonnull)(NSError * _Nonnull))onError;
/// Fetch current lookup entity,
///
/// returns:
/// nil if there is no lookup yet, entity otherwise
+ (QBLookupEntity * _Nullable)getLookupData SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#endif
