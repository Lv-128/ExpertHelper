//
//  EHITAViewControllerCell.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHITAViewControllerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *candidateName;
@property (weak, nonatomic) IBOutlet UIButton *openPopUpButton;
@property (weak, nonatomic) IBOutlet UIButton *candidateImage;
@property (weak, nonatomic) IBOutlet UISwitch *pass;

@end
