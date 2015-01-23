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
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self dateString]]

@interface EHRecorderCommentController ()
<EHSkillLevelPopupDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AVAudioSessionDelegate,
 AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    BOOL isTextView;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    NSArray *quickComments;
}

- (IBAction)recordStopButton:(UIButton *)sender;
@property (nonatomic, weak) IBOutlet UIButton *recordStopButton;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;
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
    [popup close];
    isTextView = YES;
    _levelLabel.text = popup.skillLevel;
    
    NSMutableArray *temp = [_level mutableCopy];
    [temp[_index.section] setObject:_levelLabel.text atIndex:_index.row];
    _level = temp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    quickComments = [self getCommentFromDB];
    isTextView = YES;
    [_commentView setDelegate:self];
    [_commentView setReturnKeyType:UIReturnKeyDone];

    if (_arrayOfRecordsUrl == nil) {
        _arrayOfRecordsUrl = [[NSMutableArray alloc] init];
        _arrayOfRecordsString = [[NSArray alloc]init];
    } 
    //Choose level label
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction)];
    [_levelLabel addGestureRecognizer:tap];
    _levelLabel.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[_comment objectAtIndex:_index.section]
          objectAtIndex:_index.row] isEqualToString:@""] ||
        [[[_comment objectAtIndex:_index.section]
          objectAtIndex:_index.row] isEqualToString:@"Please post your comments"]) {
        
        [_commentView setText:@"Please post your comments"];
        [_commentView setTextColor:[UIColor lightGrayColor]];
    }
    else
        _commentView.text = [[_comment objectAtIndex:_index.section] objectAtIndex:_index.row];
    
    [_commentView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    
    if (![[[_level objectAtIndex:_index.section] objectAtIndex:_index.row] isEqual:@""])
        _levelLabel.text = [[_level objectAtIndex:_index.section] objectAtIndex:_index.row];
    else
        _levelLabel.text = @"Choose level";
    
    _buttonRecord = [UIImage imageNamed:@"record_button"];
    _buttonStop = [UIImage imageNamed:@"stop_button"];
    _buttonPlay = [UIImage imageNamed:@"play_button"];
    _buttonPause = [UIImage imageNamed:@"pause_button"];
    
    [self designOfViews:_commentView];
    [self designOfViews:_infoTableView];
    [self designOfViews:_recordsTableView];
}

- (UIView *)designOfViews:(UIView *)someView
{
    someView.layer.borderWidth = 1.0f;
    someView.layer.borderColor = [UIColor grayColor].CGColor;
    someView.layer.cornerRadius = 20;
    someView.clipsToBounds = YES;
    return someView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self addCommentToDB:_commentView.text];
    
    (![[[_comment objectAtIndex:_index.section] objectAtIndex:_index.row] isEqualToString:@""]) ?
        (_skill.comment = [[_comment objectAtIndex:_index.section] objectAtIndex:_index.row]): (_skill.comment = @"");
    (![[[_level objectAtIndex:_index.section] objectAtIndex:_index.row] isEqual:@""]) ?
        (_skill.estimate = [[_level objectAtIndex:_index.section] objectAtIndex:_index.row]): (_skill.estimate = @"");
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_level, @"recorderLevel", _comment,
                          @"recorderComment", _arrayOfRecordsUrl, @"recorderUrl",
                          _arrayOfRecordsString, @"recorderName", nil];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoCompleteRowIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AutoCompleteRowIdentifier"] ;
    }
    (quickComments.count > 0) ? (cell.textLabel.text = [[quickComments objectAtIndex:indexPath.row] comment]) :
    (cell.textLabel.text = @"");
    
    return cell;
}

- (EHRecorderCommaentCell *)recordTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHRecorderCommaentCell *cell = (EHRecorderCommaentCell *)[tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    
    cell.textLabel.text = [_arrayOfRecordsString objectAtIndex:[indexPath row]];
    
    if (cell.button.isPlaying)
        [cell.button setBackgroundImage:_buttonStop forState:UIControlStateNormal];
    else
        [cell.button setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
    
    if (!player.playing) {
        [cell.button setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
        cell.button.isPlaying = NO;
    }
    
    [cell.button addTarget:self action:@selector(playPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


# pragma mark - deletingCellMethods
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView == _infoTableView
    ? [self infoTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath]
    : [self recordsTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)infoTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        EHAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[QuickComment entityName]
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        fetchRequest.predicate = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];

        NSMutableArray *temp = [quickComments mutableCopy];

        [temp removeObjectAtIndex:indexPath.row];
        quickComments = temp;
    
        for (QuickComment *myCom in fetchedObjects)
            if ([myCom isEqual:fetchedObjects[indexPath.row]])
                [context deleteObject:myCom];
        
        [_infoTableView reloadData];
    }
}

- (void)recordsTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        EHAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[AudioRecord entityName]
                                                  inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        fetchRequest.predicate = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        
        [[NSFileManager defaultManager] removeItemAtPath:_arrayOfRecordsString[indexPath.row] error:nil];
        
        NSMutableArray *tempOfString = [_arrayOfRecordsString mutableCopy];
        [tempOfString removeObjectAtIndex:indexPath.row];
        _arrayOfRecordsString = tempOfString;
        
        for (AudioRecord *myRec in fetchedObjects)
            if ([myRec isEqual:fetchedObjects[indexPath.row]])
                [context deleteObject:myRec];

        [_recordsTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _infoTableView)
        [self infoTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)infoTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    _infoTableView.hidden = YES;
    _commentView.hidden = NO;
    isTextView= YES;
    
    if ([_commentView.text isEqualToString:@"Please post your comments"])
        _commentView.text = selectedCell.textLabel.text;
    else
        _commentView.text = [_commentView.text stringByAppendingString:[@" "  stringByAppendingString: selectedCell.textLabel.text]];

    _commentView.textColor = [UIColor blackColor];
    NSMutableArray *temp = [_comment mutableCopy];
    [[temp objectAtIndex:_index.section] setObject: _commentView.text atIndex:_index.row];
    _comment = temp;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [_popup close];
    self.popup = nil;
    
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
    NSString *nibName;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        nibName = @"EHSkillLevelPopupIpad";
    else
        nibName = @"EHSkillLevelPopupIphone";

    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    EHSkillLevelPopup *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
    
    if (_popup == nil) {
        CGRect selfFrame = self.view.frame;
        CGRect popupFrame = popup.frame;
        popupFrame.size.width = selfFrame.size.width;
        popupFrame.origin.y = selfFrame.size.height;
        popupFrame.origin.y -= popupFrame.size.height;
        popup.frame = popupFrame;
        
        popup.delegate = self;
        popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
        popup.titleLabel.text = @"Select the desired level";
        _popup = popup;
        [self.view addSubview:popup];
        
        [UIView animateWithDuration:0.5 animations:^{
            popup.alpha = 1;
            popup.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } else {
        [_popup close];
        self.popup = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popup close];
    self.popup = nil;
    [self hideInfoTableView];
    [self.commentView resignFirstResponder];
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

- (IBAction)recordStopButton:(UIButton *)sender
{
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
    }
}

- (NSIndexPath *)indexPathOfButton:(UIButton *)button
{
    UIView *view = button.superview;
    while (![view isKindOfClass:[EHRecorderCommaentCell class]]) {
        view = view.superview;
    }
    return [_recordsTableView indexPathForCell:(UITableViewCell *)view];
}

- (void)playPauseButton:(EHPlayPause *)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    sender.isPlaying = !sender.isPlaying;
    if (!player.playing) {
        [sender setBackgroundImage:_buttonPause forState:UIControlStateNormal];
        if (!recorder.recording){
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:[_arrayOfRecordsUrl objectAtIndex:indexPath.row]
                                                            error:nil];
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
    [_recordsTableView reloadData];
}

#pragma mark quick comment

//int cnt;
//- (IBAction)buttonEdit:(id)sender {
//    UIButton *button = sender;
//    if (cnt == 0){
//        [self.recordsTableView setEditing:YES animated:YES];
//         button.titleLabel.text = @"Done";
//        cnt++;
//    }
//    else if (cnt == 1){
//        [self.recordsTableView setEditing:NO animated:YES];
//        button.titleLabel.text = @"Edit";
//        cnt--;
//    }
//}

- (IBAction)quickComment:(id)sender
{
    if(isTextView)
    {
        isTextView = NO;
        _infoTableView.hidden = NO;
        _commentView.hidden = YES;
    } else
        [self hideInfoTableView];
}

- (void)hideInfoTableView
{
    isTextView = YES;
    _infoTableView.hidden = YES;
    _commentView.hidden = NO;
}

- (void)addCommentToDB:(NSString *)comment
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
        if ([myCom.comment isEqualToString:comment] || [comment isEqualToString: @"Please post your comments"]
            || [comment isEqualToString: @""])
        {
            isExist = true;
        }
    }
    
    if (!isExist && !([comment isEqualToString: @"Please post your comments"] || [comment isEqualToString: @""]))
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

- (NSArray *)getCommentFromDB
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

@end




