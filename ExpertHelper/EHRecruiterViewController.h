//
//  EHRecruiterViewController.h
//  ExpertHelper
//
//  Created by alena on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EHAppDelegate.h"
@interface EHRecruiterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelNameOfRecruiter;
@property (strong, nonatomic) Recruiter *recruiter;
@property (weak, nonatomic) IBOutlet UIImageView *photoRecruiter;
@property (weak, nonatomic) IBOutlet UILabel *emailRecruiter;
@property (weak, nonatomic) IBOutlet UILabel *skypeRecruiter;
@property (weak, nonatomic) IBOutlet UIImageView *panel;

- (IBAction)skypeMe:(id)sender;

@end
