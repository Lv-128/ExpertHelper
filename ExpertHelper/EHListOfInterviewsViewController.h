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

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSArray *interviews;
@property (copy, nonatomic) NSArray *sortedWeeks;
@property (nonatomic,retain) UIPickerView *myPickerView;
@property (nonatomic) bool notFirstLoad;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
