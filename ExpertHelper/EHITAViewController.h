//
//  EHITAViewController.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHAppDelegate.h"

@interface EHITAViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPopoverControllerDelegate>
{
    NSString *selectedScore;
    IBOutlet UIButton *scoreOption;
    int scopeCount;
    int scopeCount2;
}

@property(nonatomic,retain) NSArray *scoreSrc;
@property(nonatomic,retain) UIPickerView *myPickerView;
@property(nonatomic,retain) UIPopoverController *popoverController;
@property(nonatomic,retain) UIPopoverController *popover;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *zoomButton;
@property (nonatomic, strong) InterviewAppointment *interview;

@end
