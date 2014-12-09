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
#import "EHEventsGetInfoParser.h"
@interface EHListOfInterviewsViewController : UIViewController

@property (copy, nonatomic) NSArray *interviews;
@property (strong, nonatomic) NSArray *sortedWeeks;
@property(nonatomic,retain) UIPickerView *myPickerView;
@property (nonatomic) bool notFirstLoad;
@property (strong, nonatomic) EHEventsGetInfoParser *interviewFromEventsParser;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (void) goToHR;

@end