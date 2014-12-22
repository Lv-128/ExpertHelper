//
//  EHGeneralInfoCell.h
//  ExpertHelper
//
//  Created by nvlizlo on 17.12.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHSkillsProfilesParser.h"

@interface EHGeneralInfoCell : UITableViewCell

@property (nonatomic, strong) EHGenInfo *genInfo;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *highPotentionalLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelEstimateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertName;
@property (weak, nonatomic) IBOutlet UILabel *competenceGroup;
@property (weak, nonatomic) IBOutlet UILabel *skillSummary;
@property (weak, nonatomic) IBOutlet UILabel *typeOfProject;
@property (weak, nonatomic) IBOutlet UILabel *recomendations;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@end
