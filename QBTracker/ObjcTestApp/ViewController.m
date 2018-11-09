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

- (IBAction)addEventAction:(id)sender {
    [QubitSDK sendEventWithType:@"View" data:@"{\"type\" : \"tapOnEventButton\"}"];
}
- (IBAction)createEventAction:(id)sender {
    id event = [QubitSDK createEventWithType:@"Product" data:@"{\"type\" : \"tapOnEventButton\"}"];
    [QubitSDK sendEventWithEvent:event];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
