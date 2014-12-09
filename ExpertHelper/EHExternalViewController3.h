//
//  EHExternalViewController3.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EHExternalViewController3 : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
