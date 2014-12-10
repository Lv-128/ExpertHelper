//
//  EHInterviewViewCell.h
//  ExpertHelper
//
//  Created by Katolyk S. on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHInterviewViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *skypeButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *candidateLabel;
@property (weak, nonatomic) IBOutlet UILabel *recruiterLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end
