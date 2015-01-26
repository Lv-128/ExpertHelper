//
//  EHListOfRecruitersCell.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/4/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHListOfRecruitersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recruiterEmail;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (weak, nonatomic) IBOutlet UIButton *skypeBut;
@property (weak, nonatomic) IBOutlet UIButton *mailBut;


@end
