//
//  EHExternalViewController3.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class EHRecorderCommentController;

@protocol EHRecorderCommentControllerDelegate <NSObject>

- (void)EHRecorderCommentController:(EHRecorderCommentController *)externalWithComment transmittingArray:(NSArray *)level withIndex:(NSIndexPath *)index;

@end

@interface EHRecorderCommentController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *level;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) NSArray *arrayListOfRecordSound;

@property (nonatomic, weak) id<EHRecorderCommentControllerDelegate> delegate;

@end
