//
//  FBAppEvents.m
//  InstaStream
//
//  Created by PRASHANTH SAMALA on 28/09/18.
//  Copyright © 2018 Orbysol. All rights reserved.
//

#import "FBAppEvents.h"

static FBAppEvents* sharedInstance = nil;
@implementation FBAppEvents
+(FBAppEvents*)sharedController
{
    if (sharedInstance == nil)
        sharedInstance = [[FBAppEvents alloc] init];
    return sharedInstance;
}

// Pre defined App event for Complete registration
- (void)logCompletedRegistrationEvent:(NSString *)registrationMethod {
    NSDictionary *params =
    @{FBSDKAppEventParameterNameRegistrationMethod : registrationMethod};
    [FBSDKAppEvents
     logEvent:FBSDKAppEventNameCompletedRegistration
     parameters:params];
}

@end
