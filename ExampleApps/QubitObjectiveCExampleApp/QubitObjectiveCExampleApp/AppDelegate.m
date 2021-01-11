//
//  AppDelegate.m
//  QubitObjectiveCExampleApp
//
//  Created by Pavlo Davydiuk on 30/08/2017.
//  Copyright © 2017 Qubiit. All rights reserved.
//

#import "AppDelegate.h"
#import "QubitSDK/QubitSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [QubitSDK startWithTrackingId:@"test" logLevel:QBLogLevelVerbose];
    
    return YES;
}

@end
