//
//  EHViewController.h
//  ExpertHelper
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EHViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    BOOL isShaking;
}

@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)playTapped:(id)sender;

@end
