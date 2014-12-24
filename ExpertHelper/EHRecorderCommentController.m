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
#import "EHSkillsProfilesParser.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define DOCUMENTS_FOLDER1 [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"Recordering"]
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self dateString]]

@interface EHRecorderCommentController () <EHSkillLevelPopupDelegate, UITextViewDelegate, AVAudioSessionDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    NSURL *temporaryRecFile;
    BOOL buttonRecordPressed;
    BOOL buttonPlayPressed;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isTextView;
    NSArray *quickComments;
}

- (IBAction)recordStopButton:(UIButton *)sender;
@property (nonatomic, weak) IBOutlet UIButton *recordStopButton;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableForRecords;
@property (nonatomic, weak) IBOutlet UITextView *commentView;
@property (nonatomic, strong) UIImage *buttonRecord;
@property (nonatomic, strong) UIImage *buttonStop;
@property (nonatomic, strong) UIImage *buttonPlay;
@property (nonatomic, strong) UIImage *buttonPause;
@property (nonatomic, strong) EHSkillLevelPopup *popup;


@end

@implementation EHRecorderCommentController

- (void)skillLevelPopup:(EHSkillLevelPopup *)popup
         didSelectLevel:(EHSkillLevel)level
{
    isTextView = YES;

    [popup close];
    
    _levelLabel.text = popup.skillLevel;
    
    NSMutableArray *temp = [_level mutableCopy];
    [temp[_index.section] setObject:_levelLabel.text atIndex:_index.row];
    _level = temp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
<<<<<<< Updated upstream
    isPopup = NO;
    quickComments = [self getCommentFromDB];
    isTextView = YES;
=======
    
>>>>>>> Stashed changes
    [_commentView setDelegate:self];
    [_commentView setReturnKeyType:UIReturnKeyDone];
    
    if ([[[_comment objectAtIndex:_index.section] objectAtIndex:_index.row] isEqualToString:@""] || [[[_comment objectAtIndex:_index.section] objectAtIndex:_index.row] isEqualToString:@"Please post your comments"]) {
        [_commentView setText:@"Please post your comments"];
        [_commentView setTextColor:[UIColor lightGrayColor]];
    }else{
        _commentView.text = [[_comment objectAtIndex:_index.section] objectAtIndex:_index.row];
    }
    
    [_commentView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    
    if (![[[_level objectAtIndex:_index.section] objectAtIndex:_index.row] isEqual:@""]) {
        _levelLabel.text = [[_level objectAtIndex:_index.section] objectAtIndex:_index.row];
    }else{
        _levelLabel.text = @"Choose level";
    }
    
    _buttonRecord = [UIImage imageNamed:@"record_button"];
    _buttonStop = [UIImage imageNamed:@"stop_button"];
    _buttonPlay = [UIImage imageNamed:@"play_button"];
    _buttonPause = [UIImage imageNamed:@"pause_button"];
    
    _commentView.layer.borderWidth = 2.0f;
    _commentView.layer.cornerRadius = 20;
    _commentView.clipsToBounds = YES;
    
    _tableForRecords.layer.borderWidth = 2.0f;
    _tableForRecords.layer.cornerRadius = 20;
    _tableForRecords.clipsToBounds = YES;
    
    if (_arrayOfRecordsUrl == nil) {
        _arrayOfRecordsUrl = [[NSMutableArray alloc] init];
        _arrayOfRecordsString = [[NSArray alloc]init];
    }
    
    //Choose level label
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction)];
    [_levelLabel addGestureRecognizer:tap];
    _levelLabel.userInteractionEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self addCommentToDB:_commentView.text];
    (![[[_comment objectAtIndex:_index.section] objectAtIndex:_index.row] isEqualToString:@""]) ? (_skill.comment = [[_comment objectAtIndex:_index.section] objectAtIndex:_index.row]): (_skill.comment = @"");
    (![[[_level objectAtIndex:_index.section] objectAtIndex:_index.row] isEqual:@""]) ? (_skill.estimate = [[_level objectAtIndex:_index.section] objectAtIndex:_index.row]): (_skill.estimate = @"");
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_level, @"recorderLevel", _comment, @"recorderComment", _arrayOfRecordsUrl, @"recorderUrl", _arrayOfRecordsString, @"recorderName", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RecorderComment" object:nil userInfo:dict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView == _infoTableView
    ? [self tableView:tableView numberOfRowsInSectionInfoTable:section]
    : [self tableView:tableView numberOfRowsInSectionRecordsTable:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionRecordsTable:(NSInteger)section
{
    return _arrayOfRecordsString.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionInfoTable:(NSInteger)section
{
    if (quickComments.count == 0)
        return 3;
    else
        return quickComments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView == _infoTableView
    ? [self infoTableView:tableView cellForRowAtIndexPath:indexPath]
    : [self recordTableView:tableView cellForRowAtIndexPath:indexPath];
    
}

- (UITableViewCell *)infoTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier] ;
    }
    (quickComments.count>0) ? (cell.textLabel.text = [[quickComments objectAtIndex:indexPath.row] comment]) :
                              (cell.textLabel.text = @"");
        
    
    return cell;
}

- (EHRecorderCommaentCell *)recordTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHRecorderCommaentCell *cell = (EHRecorderCommaentCell *)[tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    
    cell.textLabel.text = [_arrayOfRecordsString objectAtIndex:[indexPath row]];
    
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




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView == _infoTableView
    ? [self infoTableView:tableView didSelectRowAtIndexPath:indexPath]
    : [self recordsTableView:tableView didSelectRowAtIndexPath:indexPath];
    
}


- (void)infoTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    _infoTableView.hidden = YES;
    _commentView.hidden = NO;
    isTextView= YES;
    if ([_commentView.text isEqualToString:@"Please post your comments"])
        _commentView.text = selectedCell.textLabel.text;
     else
         _commentView.text = [_commentView.text stringByAppendingString:selectedCell.textLabel.text];
    
}


- (void)recordsTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHRecorderCommaentCell *cell = (EHRecorderCommaentCell *)[tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    [self playPauseButton:(EHPlayPause *)cell.button];
    
    cell.button.tag = indexPath.row;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.recordsTableView reloadData];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [_popup close];
    if (_commentView.textColor == [UIColor lightGrayColor]) {
        _commentView.text = @"";
        _commentView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\n" options:0 error:NULL];
    NSUInteger a = [regex numberOfMatchesInString:textView.text options:0 range:NSMakeRange(0, [textView.text length])];
    
    if(_commentView.text.length == 0||a)
    {
        _commentView.textColor = [UIColor lightGrayColor];
        _commentView.text = @"Please post your comments";
        [_commentView resignFirstResponder];
    }
    
    
    NSMutableArray *temp = [_comment mutableCopy];
    [[temp objectAtIndex:_index.section] setObject: _commentView.text atIndex:_index.row];
    _comment = temp;
    return YES;
}

- (void)pushAction
{
    if (_popup == nil){
        NSString *nibName;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            nibName = @"EHSkillLevelPopupIpad";
        else
            nibName = @"EHSkillLevelPopupIphone";
        
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        EHSkillLevelPopup *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
        [popup showInView:self.view];
        popup.delegate = self;
        popup.titleLabel.text = @"Select the desired level";
        self.popup = popup;
    } else {
        [_popup close];
        self.popup = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popup close];
}

- (NSString *)dateString
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd.MMM.YYYY_hh:mm:ssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".m4a"];
}

- (void)prepareToRecording
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [audioSession setActive:YES error:nil];
    
    [recorder setDelegate:self];
    
    ///
    // Set the audio file
    
    // File URL
    NSURL *url = [NSURL fileURLWithPath:FILEPATH];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setURL:url forKey:@"Test1"];
    [prefs synchronize];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (IBAction)recordStopButton:(UIButton *)sender {
    
    NSMutableArray *recordsTransmitting = [_arrayOfRecordsUrl mutableCopy];
    NSMutableArray *recordsStringTransmitting = [_arrayOfRecordsString mutableCopy];
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        [sender setBackgroundImage:_buttonStop forState:UIControlStateNormal];
        [self prepareToRecording];
        // Start recording
        [recorder record];
    } else {
        [recorder stop];
        
        [sender setBackgroundImage:self.buttonRecord forState:UIControlStateNormal];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        NSURL *url = recorder.url;
        [recordsTransmitting addObject:url];
        _arrayOfRecordsUrl = recordsTransmitting;
        
        NSString *str = [url absoluteString];
        NSString *truncatedString = [str substringFromIndex:[str length] - 26];
        [recordsStringTransmitting addObject:truncatedString];
        _arrayOfRecordsString = recordsStringTransmitting;
        
        [_recordsTableView reloadData];
        
        //[recordsTransmitting addObject:audioSession];
        //_genInfo.records = recordsTransmitting;
    }
}

- (NSIndexPath *)indexPathOfButton:(UIButton *)button {
    UIView *view = button.superview;
    while (![view isKindOfClass:[EHRecorderCommaentCell class]]) {
        view = view.superview;
    }
    return [_recordsTableView indexPathForCell:(UITableViewCell *)view];
}

- (void)playPauseButton:(EHPlayPause *)sender {
    UIButton *button = sender;
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    sender.isPlaying = !sender.isPlaying;
    if (!player.playing) {
        [sender setBackgroundImage:_buttonPause forState:UIControlStateNormal];
        if (!recorder.recording){
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:[_arrayOfRecordsUrl objectAtIndex:indexPath.row] error:nil];
            [player setDelegate:self];
            [player play];
        }
    } else {
        [player stop];
        
        [sender setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
    }
    [_recordsTableView reloadData];
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
    [_recordsTableView reloadData];
}


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

#pragma mark quick comment

- (IBAction)quickComment:(id)sender {
    
    if(isTextView)
    {
        isTextView = NO;
        _infoTableView.hidden = NO;
        _commentView.hidden = YES;
    }
    else {
        isTextView = YES;
        _infoTableView.hidden = YES;
        _commentView.hidden = NO;
    }
}

<<<<<<< Updated upstream

- (void) addCommentToDB:(NSString *)comment
{
    EHAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[QuickComment entityName]
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    BOOL isExist = false;
    for (QuickComment *myCom in fetchedObjects)
    {
        
        if ([myCom.comment isEqualToString:comment])
        {
            isExist = true;
        }
    }
    if (!isExist)
    {
       QuickComment *com = [NSEntityDescription
                          insertNewObjectForEntityForName:[QuickComment entityName]
                          inManagedObjectContext:context];
        com.comment = comment;
    }
    
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}
- (NSArray *) getCommentFromDB
{
    EHAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[QuickComment entityName]
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
    
    
}
=======
>>>>>>> Stashed changes
@end




