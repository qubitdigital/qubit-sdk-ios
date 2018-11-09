//
//  ViewController.m
//  ObjcTestApp
//
//  Created by Jacek Grygiel on 18/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [QubitSDK startWithTrackingId:@"miquido" logLevel:QBLogLevelVerbose];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchExperiences];
}

- (void)fetchExperiences {
    [QubitSDK fetchExperiencesWithIds:@[@143401] onSuccess:^(NSArray<QBExperienceEntity *> * _Nonnull experiences) {
        NSLog(@"Fetched %lu Experiences", experiences.count);
        QBExperienceEntity* firstEntity = experiences.firstObject;
        [firstEntity shown];
    } onError:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
    } preview:false variation:false ignoreSegments:false];
}

- (IBAction)addEventAction:(id)sender {
    [QubitSDK sendEventWithType:@"View" data:@"{\"type\" : \"tapOnEventButton\"}"];
}
- (IBAction)createEventAction:(id)sender {
    id event = [QubitSDK createEventWithType:@"Product" data:@"{\"type\" : \"tapOnEventButton\"}"];
    [QubitSDK sendEventWithEvent:event];
}

@end
