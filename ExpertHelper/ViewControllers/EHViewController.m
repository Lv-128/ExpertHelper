//
//  EHViewController.m
//  ExpertHelper
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHViewController.h"
#import "EHSkillLevelPopup.h"


@interface EHViewController () <EHSkillLevelPopupDelegate>{
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
}
@end

@implementation EHViewController
@synthesize playButton;


- (void)skillLevelPopupDelegate:(EHSkillLevelPopup *)popup didSelectLevel:(BOOL)goToComments {
    if (goToComments == YES) {
        UIViewController *push2 = [[UIViewController alloc]init];
        [[self navigationController]pushViewController:push2 animated:YES];
    }
}

- (void)viewDidLoad
{
    [playButton setEnabled:NO];
    isShaking = NO;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (IBAction)openPopup:(id)sender
{
    UINib *nib = [UINib nibWithNibName:@"EHSkillLevelPopup" bundle:nil];
    EHSkillLevelPopup *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
    CGRect r = self.view.frame;
    CGRect f = popup.frame;
    f.size.width = r.size.width;
    f.origin.y = r.size.height;
    f.origin.y -= f.size.height;
    popup.frame = f;
    popup.delegate = self;
    popup.layer.cornerRadius = 6;
    popup.layer.shadowOpacity = 0.8;
    //popup.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
    popup.alpha = 0;
    [self.view addSubview:popup];
    
    [UIView animateWithDuration:0.5 animations:^{
        //CGRect f = popup.frame;
        //popup.frame = f;
        popup.alpha = 1;
        popup.transform = CGAffineTransformMakeScale(1, 1);
    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        
        //alertView for Controll
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Start recording" message:@"Please talk!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        isShaking = YES;
    }else{
        [recorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        //alertView for Controll
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish recording" message:@"Press Play Button!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        isShaking = NO;
    }
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}



#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [playButton setEnabled:YES];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end
