//
//  EHExternalViewController3.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EHSkillsProfilesParser.h"

@interface EHRecorderCommentController : UIViewController <UITableViewDataSource, UITableViewDelegate,
AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *infoTableView;
@property (nonatomic, weak) IBOutlet UITableView *recordsTableView;
@property (nonatomic, strong) NSArray *comment;
@property (nonatomic, strong) NSArray *level;
@property (nonatomic, copy) NSArray *arrayOfRecordsUrl;
@property (nonatomic, copy) NSArray *arrayOfRecordsString;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) EHGenInfo *genInfo;
@property (nonatomic, strong) EHSkill *skill;
@property (nonatomic) NSInteger indexOfCell;

- (IBAction)quickComment:(id)sender;

@end
