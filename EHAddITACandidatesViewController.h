//
//  EHAddITACandidatesViewController.h
//  ExpertHelper
//
//  Created by adminaccount on 1/28/15.
//  Copyright (c) 2015 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHAppDelegate.h"

@interface EHAddITACandidatesViewController : UIViewController

@property (nonatomic, strong) InterviewAppointment *interview;
@property (nonatomic, weak) IBOutlet UITextField *firstName;
@property (nonatomic, weak) IBOutlet UITextField *lastName;
- (IBAction)addCandidate:(id)sender;

@end
