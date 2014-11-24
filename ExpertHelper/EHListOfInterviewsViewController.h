//
//  EHListOfInterviewsViewController.h
//  ExpertHelper
//
//  Created by alena on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHRevealViewController.h"

@interface EHListOfInterviewsViewController : UIViewController

@property (copy, nonatomic) NSArray * interviews;
@property (strong, nonatomic) NSArray *sortedWeeks;
- (IBAction)skypeMe:(id)sender;


@end
