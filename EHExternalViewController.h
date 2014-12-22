//
//  CLExternalViewController.h
//  firstCalendarFrom
//
//  Created by alena on 10/30/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHAppDelegate.h"
@interface EHExternalViewController : UIViewController
{
    BOOL isPopup;
    BOOL newCell;
    NSInteger RowAtIndexPathOfSkills;
    NSInteger lostData;
}
@property (nonatomic, strong) InterviewAppointment * currentInterviewDescription;
@property (nonatomic, strong) ExternalInterview * currentExternalInterview;
@property (nonatomic, strong) InterviewAppointment *interview;
@property (nonatomic, strong) NSIndexPath *index;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UIPopoverController *recorder;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButMenu;


@end
