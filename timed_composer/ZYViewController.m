//
//  ZYViewController.m
//  timed_composer
//
//  Created by Mariano Abdala on 4/15/12.
//  Copyright (c) 2012 Zerously.com. All rights reserved.
//

#import "ZYViewController.h"

@interface ZYViewController () <
    MFMailComposeViewControllerDelegate,
    UIAlertViewDelegate,
    UIActionSheetDelegate>

@property (nonatomic, strong) MFMailComposeViewController *composeViewController;

- (IBAction)composeButtonTapped:(id)sender;
- (void)dismissKeyboard;
- (void)showDeleteCancelActionSheet;
- (void)pushPushNotificationDetailViewController;

@end

@implementation ZYViewController

@synthesize composeViewController = _composeViewController;

#pragma mark - Self
#pragma mark ZYViewController
- (void)localPushNotificationReceived {
    
    UIAlertView *notificationAlertView =
    [[UIAlertView alloc] initWithTitle:@"Local push notification"
                               message:@"30 seconds have elapsed, tap view to see the detail."
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"View", nil];
    
    [notificationAlertView show];
}

#pragma mark ZYViewController ()
- (IBAction)composeButtonTapped:(id)sender {

    if ([MFMailComposeViewController canSendMail] == NO) {
        
        return;
    }

    //Schedule the notification to fire up in 30 seconds.
    UILocalNotification *localNotification =
    [[UILocalNotification alloc] init];
    
    localNotification.fireDate =
    [NSDate dateWithTimeIntervalSinceNow:30];
    
    localNotification.alertBody =
    @"An urgent notification just arrived.";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    //Present the mail composer.
    self.composeViewController =
	[[MFMailComposeViewController alloc] init];
	
	self.composeViewController.mailComposeDelegate = self;
    
    [self presentModalViewController:self.composeViewController
                            animated:YES];
}

- (void)dismissKeyboard {
    
    //Boy, is this an awful hack or not?
    //It does work.
    UITextField *tempTextField =
    [[UITextField alloc] initWithFrame:CGRectZero];
    
    [self.composeViewController.view addSubview:tempTextField];
    [tempTextField becomeFirstResponder];
    [tempTextField resignFirstResponder];
    [tempTextField removeFromSuperview];
}

- (void)showDeleteCancelActionSheet {
 
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:@"In order to show the push notification detail, this message must be closed first."
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:@"Delete Draft"
                       otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];
}

- (void)pushPushNotificationDetailViewController {
    
    [self performSegueWithIdentifier:@"pushNotificationDetailSegue"
                              sender:self];
}

#pragma mark - Protocols
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    //Avoid pending notifiations to fire once the mail composer have been dismissed.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self.composeViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    [alertView dismissWithClickedButtonIndex:buttonIndex
                                    animated:YES];

    int cancelButtonIndex = 0;
    
    if (buttonIndex == cancelButtonIndex) {
        
        return;
    }
    
    [self dismissKeyboard];
    [self showDeleteCancelActionSheet];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    [actionSheet dismissWithClickedButtonIndex:buttonIndex
                                      animated:YES];

    int cancelButtonIndex = 1;
    
    if (buttonIndex == cancelButtonIndex) {
        
        return;
    }

    [self pushPushNotificationDetailViewController];
    [self.composeViewController dismissModalViewControllerAnimated:YES];
}

@end
