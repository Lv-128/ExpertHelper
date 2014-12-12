//
//  EHAppDelegate.h
//  ExpertHelper
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
//#import "EHFacebookPopoverViewController.h"
#import "EHConstantsDefines.h"
@interface EHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (strong, nonatomic) EHFacebookPopoverViewController *popoverController;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;
@end
