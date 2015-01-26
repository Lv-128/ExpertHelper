//
//  EHListOfInterviewsViewController.h
//  ExpertHelper
//
//  Created by alena on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHRevealViewController.h"
#import "EHAppDelegate.h"

@interface EHListOfInterviewsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *interviews;
@property (nonatomic, copy) NSArray *sortedWeeks;
@property (nonatomic) bool notFirstLoad;
@property (nonatomic, strong) UIPopoverController *recruteirPopover;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
