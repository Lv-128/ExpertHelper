//
//  EHExternalViewController3.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHExternalViewController3.h"
#import "EHSkillLevelPopup.h"

@interface EHExternalViewController3 () <EHSkillLevelPopupDelegate>
{
    BOOL buttonRecordPressed;
    BOOL buttonPlayPressed;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isPopup;
}

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableForRecords;
@property (copy, nonatomic) NSArray *arrayOfRecords;
@property (strong, nonatomic) UIImage *buttonRecord;
@property (strong, nonatomic) UIImage *buttonStop;
@property (strong, nonatomic) UIImage *buttonPlay;
@property (strong, nonatomic) UIImage *buttonPause;

- (IBAction)recordStopButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordStopButton;

@end

@implementation EHExternalViewController3

- (void)skillLevelPopup:(EHSkillLevelPopup *)popup
         didSelectLevel:(EHSkillLevel)level {
    
    [UIView animateWithDuration:0.85 animations:^{
        popup.transform = CGAffineTransformMakeScale(0, 0);
        popup.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [super viewDidLoad];
    }];
    isPopup = NO;
    
    _levelLabel.text = popup.skillLevel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isPopup = NO;
    
    _buttonRecord = [UIImage imageNamed:@"record_button"];
    _buttonStop = [UIImage imageNamed:@"stop_button"];
    _buttonPlay = [UIImage imageNamed:@"play_button"];
    _buttonPause = [UIImage imageNamed:@"pause_button"];
    
    _commentTextView.layer.borderWidth = 2.0f;
    _commentTextView.layer.cornerRadius = 20;
    _commentTextView.clipsToBounds = YES;
    
    _tableForRecords.layer.borderWidth = 2.0f;
    _tableForRecords.layer.cornerRadius = 20;
    _tableForRecords.clipsToBounds = YES;
    
    _arrayOfRecords =[[NSArray alloc] initWithObjects:@"record 1", @"record 2", @"record 3", nil];
    
    ///
    // Set the audio file
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
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    //Choose level label
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction)];
    [_levelLabel addGestureRecognizer:tap];
    _levelLabel.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    cell.textLabel.text = _arrayOfRecords[indexPath.row];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(cell.frame.size.width - (cell.frame.size.height + 5), cell.frame.origin.y, cell.frame.size.height, cell.frame.size.height);
    if (player.playing) {
        [button setBackgroundImage:_buttonStop forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
    }
  
    [button addTarget:self action:@selector(playPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
    
    return cell;
}

- (IBAction)recordStopButton:(UIButton *)sender {
    if (player.playing) {
        [player stop];
    }

    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [sender setBackgroundImage:_buttonStop forState:UIControlStateNormal];
        // Start recording
        [recorder record];
    } else {
        [recorder stop];
        
        [sender setBackgroundImage:self.buttonRecord forState:UIControlStateNormal];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    }
}

- (void)pushAction
{
    UINib *nib = [UINib nibWithNibName:@"EHSkillLevelPopup" bundle:nil];
    EHSkillLevelPopup *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
    
    if (isPopup == NO) {
        CGRect selfFrame = self.view.frame;
        CGRect popupFrame = popup.frame;
        popupFrame.size.width = selfFrame.size.width;
        popupFrame.origin.y = selfFrame.size.height;
        popupFrame.origin.y -= popupFrame.size.height;
        popup.frame = popupFrame;
        
        popup.delegate = self;
        popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
        popup.titleLabel.text = @"Select the desired level";
        [self.view addSubview:popup];
        
        [UIView animateWithDuration:0.5 animations:^{
            popup.alpha = 1;
            popup.transform = CGAffineTransformMakeScale(1, 1);
        }];
        isPopup = YES;
    }
}

- (IBAction)playPauseButton:(UIButton *)sender {
    if (!player.playing) {
        [sender setBackgroundImage:_buttonPause forState:UIControlStateNormal];
        if (!recorder.recording){
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
            [player setDelegate:self];
            [player play];
        }
    } else {
        [player stop];

        [sender setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    [_recordStopButton setBackgroundImage:_buttonRecord forState:UIControlStateNormal];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish recording" message:@"Recording successfully saved" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [_tableView reloadData];
}

@end


