//
//  EHExternalViewController3.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHRecorderCommentController.h"
#import "EHExternalViewController.h"
#import "EHSkillLevelPopup.h"
#import "EHRecorderCommaentCell.h"


@interface EHRecorderCommentController () <EHSkillLevelPopupDelegate, UITextViewDelegate, AVAudioSessionDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    NSURL *temporaryRecFile;
    BOOL buttonRecordPressed;
    BOOL buttonPlayPressed;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isPopup;
}

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableForRecords;
@property (copy, nonatomic) NSArray *arrayOfRecords;
@property (strong, nonatomic) UIImage *buttonRecord;
@property (strong, nonatomic) UIImage *buttonStop;
@property (strong, nonatomic) UIImage *buttonPlay;
@property (strong, nonatomic) UIImage *buttonPause;
@property (weak, nonatomic) IBOutlet UITextView *commentView;

- (IBAction)recordStopButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordStopButton;

@end

@implementation EHRecorderCommentController

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
    
    NSMutableArray *temp = [_level mutableCopy];
    [temp[_index.section] setObject:_levelLabel.text atIndex:_index.row];
    _level = temp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isPopup = NO;
    
    [_commentView setDelegate:self];
    [_commentView setReturnKeyType:UIReturnKeyDone];
    [_commentView setText:@"Please post your comments"];
    [_commentView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    [_commentView setTextColor:[UIColor lightGrayColor]];
    
    if (![[[_level objectAtIndex:_index.section] objectAtIndex:_index.row] isEqual:@""]) {
        _levelLabel.text = [[_level objectAtIndex:_index.section] objectAtIndex:_index.row];
    }else{
        _levelLabel.text = @"Choose level";
    }
    
    _buttonRecord = [UIImage imageNamed:@"record_button"];
    _buttonStop = [UIImage imageNamed:@"stop_button"];
    _buttonPlay = [UIImage imageNamed:@"play_button"];
    
    _commentView.layer.borderWidth = 2.0f;
    _commentView.layer.cornerRadius = 20;
    _commentView.clipsToBounds = YES;
    
    _tableForRecords.layer.borderWidth = 2.0f;
    _tableForRecords.layer.cornerRadius = 20;
    _tableForRecords.clipsToBounds = YES;
    
    _arrayOfRecords = [[NSArray alloc] initWithObjects:@"record 1", @"record 2", @"record 3", nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [audioSession setActive:YES error:nil];
    
    [recorder setDelegate:self];
    
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_delegate EHRecorderCommentController:self transmittingArray:_level withIndex:_index andCommentArray:_comment];
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

- (EHRecorderCommaentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHRecorderCommaentCell *cell = (EHRecorderCommaentCell *)[tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    cell.textLabel.text = _arrayOfRecords[indexPath.row];
    
    if (cell.button.isPlaying) {
        [cell.button setBackgroundImage:_buttonStop forState:UIControlStateNormal];
    } else {
        [cell.button setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
    }
    
    if (!player.playing) {
        [cell.button setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
        cell.button.isPlaying = NO;
    }
  
    [cell.button addTarget:self action:@selector(playPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (_commentView.textColor == [UIColor lightGrayColor]) {
        _commentView.text = @"";
        _commentView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"$\\n" options:0 error:NULL];
    NSUInteger a = [regex numberOfMatchesInString:textView.text options:0 range:NSMakeRange(0, [textView.text length])];
    
    if(_commentView.text.length == 0||a){
        _commentView.textColor = [UIColor lightGrayColor];
        _commentView.text = @"Please post your comments";
        [_commentView resignFirstResponder];
    }else{
//        NSMutableArray *commentTemp = [_comment mutableCopy];
//        [commentTemp[_index.section] setObject:_commentView.text forKey:_index.row];
//        _comment = commentTemp;
    }
    return YES;
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

- (IBAction)recordStopButton:(UIButton *)sender {
    if (player.playing) {
        [player stop];
    }

    if (!recorder.recording) {
        [self record];
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

- (IBAction)playPauseButton:(EHPlayPause *)sender {
    sender.isPlaying = !sender.isPlaying;
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish recording"
                                                        message:@"Recording successfully saved"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
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




- (NSString *)dateString
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
}

//- (BOOL)startAudioSession
//{
//    // Prepare the audio session
//    NSError *error;
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    
//    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
//    {
//        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
//        return NO;
//    }
//    
//    
//    if (![session setActive:YES error:&error])
//    {
//        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
//        return NO;
//    }
//    
//    return session.inputAvailable;
//}

- (BOOL)record
{
    NSError *error;
    
    // Recording settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    
    [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [settings setValue: [NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [settings setValue: [NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    
    NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:[self dateString]];
    
    // File URL
    NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setURL:url forKey:@"Test1"];
    [prefs synchronize];
    
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:settings error:&error];
    recorder.meteringEnabled = YES;
    
    [recorder prepareToRecord];
    [recorder record];
    
    // Create recorder
//    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
//    if (!recorder)
//    {
//        NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
//        return NO;
//    }
//    
//    // Initialize degate, metering, etc.
//    recorder.delegate = self;
//    recorder.meteringEnabled = YES;
//    //self.title = @"0:00";
//
//    if (![recorder prepareToRecord])
//    {
//        NSLog(@"Error: Prepare to record failed");
//        //[self say:@"Error while preparing recording"];
//        return NO;
//    }
//    
//    if (![recorder record])
//    {
//        NSLog(@"Error: Record failed");
//        //  [self say:@"Error while attempting to record audio"];
//        return NO;
//    }
    
    // Set a timer to monitor levels, current time
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
    return YES;
}

- (void)playBack
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:YES error:nil];
    
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    temporaryRecFile = [prefs URLForKey:@"Test1"];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
    
    player.delegate = self;
    
    [player setNumberOfLoops:0];
    player.volume = 1;
    
//    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"aif"];
//    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//
//    
//    if ([fileManager fileExistsAtPath:[self recordingFolder]])
//    {
//        
//        _arrayListOfRecordSound = [[NSMutableArray alloc]initWithArray:[fileManager  contentsOfDirectoryAtPath:documentPath_ error:nil]];
//        
//        NSLog(@"====%@", _arrayListOfRecordSound);
//        
//    }
//    
//    NSString *selectedSound = [documentPath_ stringByAppendingPathComponent:[_arrayListOfRecordSound objectAtIndex:0]];
//    
//
//    
//    //Start playback
//    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    
//    if (!player)
//    {
//        NSLog(@"Error establishing player for %@: %@", recorder.url, error.localizedFailureReason);
//        return;
//    }
//    
//    player.delegate = self;
//    
//    // Change audio session for playback
//    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error])
//    {
//        NSLog(@"Error updating audio session: %@", error.localizedFailureReason);
//        return;
//    }
//    
//    self.title = @"Playing back recording...";
    
    [player prepareToPlay];
    [player play];
}
//
//- (void)stopRecording
//{
//    // This causes the didFinishRecording delegate method to fire
//    [recorder stop];
//}
//
//- (void)continueRecording
//{
//    // resume from a paused recording
//    [recorder record];
//}
//
//- (void)pauseRecording
//{  // pause an ongoing recording
//    [recorder pause];
//}

@end




