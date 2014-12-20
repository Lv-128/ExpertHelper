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

- (void)EHRecorderCommentController:(EHRecorderCommentController *)externalWithComment
                  transmittingArray:(NSArray *)level
                          withIndex:(NSIndexPath *)index
                    andCommentArray:(NSArray *)comment;
@end

@interface EHRecorderCommentController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *comment;
@property (nonatomic, strong) NSArray *level;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic) NSInteger indexOfCell;

@property (nonatomic, weak) id<EHRecorderCommentControllerDelegate> delegate;

@end
