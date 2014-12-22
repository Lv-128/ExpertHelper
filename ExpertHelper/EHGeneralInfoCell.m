//
//  EHGeneralInfoCell.m
//  ExpertHelper
//
//  Created by nvlizlo on 17.12.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHGeneralInfoCell.h"
#import "EHRoundedAngleTextField.h"

@interface EHGeneralInfoCell ()

@property (strong, nonatomic) NSDateFormatter *formatter;

@property (copy, nonatomic) NSArray *englishArray;
@property (copy, nonatomic) NSArray *highPotentionalArray;
@property (copy, nonatomic) NSArray *levelEstimateArray;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EHGeneralInfoCell

- (NSDateFormatter *)formatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"dd-MM-yyyy";
    }
    return _formatter;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dateLabel.text = [self.formatter stringFromDate:[NSDate date]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(_genInfo == nil)
    {
        _genInfo = [[EHGenInfo alloc] init];
    }
    else
    {
        self.expertName.text = _genInfo.expertName;
        //  self.dateLabel.text = _genInfo.dateOfInterview;
        self.competenceGroup.text = _genInfo.competenceGroup;
        self.typeOfProject.text = _genInfo.typeOfProject;
        self.skillSummary.text = _genInfo.skillsSummary;
        self.englishLabel.text = _genInfo.techEnglish;
        self.recomendations.text = _genInfo.recommendations;
        //   self.levelEstimateTextField.text = _genInfo.levelEstimate;
        self.switchView.on = _genInfo.hire;
        
    }
}

@end
