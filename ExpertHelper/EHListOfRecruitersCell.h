//
//  EHListOfRecruitersCell.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/4/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHListOfRecruitersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recruiterImage;
@property (weak, nonatomic) IBOutlet UILabel *recruiterName;
@property (weak, nonatomic) IBOutlet UILabel *recruiterNumber;
@property (weak, nonatomic) IBOutlet UILabel *recruiterSkypeNumber;

@end
