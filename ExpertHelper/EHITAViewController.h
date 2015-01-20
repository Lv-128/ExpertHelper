//
//  EHITAViewController.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHITAViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSString *selectedScore;
    IBOutlet UIButton *scoreOption;
    BOOL isFive;
    int scopeCount;
    int scopeCount2;
}

@property(nonatomic,retain) NSArray *scoreSrc;
@property(nonatomic,retain) UIPickerView *myPickerView;
@property(nonatomic,retain) UIPopoverController *popoverController;

@end
