//
//  ZYAppDelegate.m
//  timed_composer
//
//  Created by Mariano Abdala on 4/15/12.
//  Copyright (c) 2012 Zerously.com. All rights reserved.
//

#import "ZYAppDelegate.h"
#import "ZYViewController.h"

@interface ZYAppDelegate () <
    UIAlertViewDelegate,
    UIActionSheetDelegate>

@end

@implementation ZYAppDelegate

@synthesize window = _window;

#pragma mark - Protocols
#pragma mark UIApplicationDelegate
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    //Not idea, but saves me a lot of code.
    UINavigationController *navigationController =
    (UINavigationController *)self.window.rootViewController;
    
    ZYViewController *viewController =
    (ZYViewController *)[navigationController.viewControllers objectAtIndex:0];
    
    [viewController localPushNotificationReceived];
}

@end
