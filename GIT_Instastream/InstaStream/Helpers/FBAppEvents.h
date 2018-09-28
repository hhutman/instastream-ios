//
//  FBAppEvents.h
//  InstaStream
//
//  Created by PRASHANTH SAMALA on 28/09/18.
//  Copyright © 2018 Orbysol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FBAppEvents : NSObject
+(FBAppEvents*)sharedController;
- (void)logCompletedRegistrationEvent:(NSString *)registrationMethod;
@end
