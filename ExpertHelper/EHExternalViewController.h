//
//  CLExternalViewController.h
//  firstCalendarFrom
//
//  Created by alena on 10/30/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHExternalViewController : UIViewController
{
    BOOL isPopup;
    BOOL newCell;
    NSInteger RowAtIndexPathOfSkills;
    NSInteger lostData;
}

@property (nonatomic, copy) NSString *skillusLevel;

@end
