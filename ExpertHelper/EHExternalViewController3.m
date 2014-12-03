//
//  EHExternalViewController3.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHExternalViewController3.h"

@interface EHExternalViewController3 ()
{
    BOOL buttonRecordPressed;
    BOOL buttonPlayPressed;
}

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableForRecords;
@property (copy, nonatomic) NSArray *arrayOfRecords;
- (IBAction)recordStopButton:(UIButton *)sender;
@property (weak, nonatomic) UIImage *buttonRecord;
@property (weak, nonatomic) UIImage *buttonStop;
@property (weak, nonatomic) UIImage *buttonPlay;
@property (weak, nonatomic) UIImage *buttonPause;

@end

@implementation EHExternalViewController3

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
    buttonRecordPressed = NO;
    buttonPlayPressed = NO;
    
    _buttonRecord = [UIImage imageNamed:@"record_button"];
    _buttonStop = [UIImage imageNamed:@"stop_button"];
    _buttonPlay = [UIImage imageNamed:@"play_button"];
    _buttonPause = [UIImage imageNamed:@"pause_button"];
    
    [_commentTextView.layer setBorderColor:[[UIColor blueColor] CGColor]];
    _commentTextView.layer.borderWidth = 2.0f;
    _commentTextView.layer.cornerRadius = 20;
    _commentTextView.clipsToBounds = YES;
    
    [_tableForRecords.layer setBorderColor:[[UIColor blueColor] CGColor]];
    _tableForRecords.layer.borderWidth = 2.0f;
    _tableForRecords.layer.cornerRadius = 20;
    _tableForRecords.clipsToBounds = YES;
    
    _arrayOfRecords =[[NSArray alloc] initWithObjects:@"record 1", @"record 2", @"record 3", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"RecordCell"];
    }
    
    cell.textLabel.text = _arrayOfRecords[indexPath.row];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(cell.frame.size.width - (cell.frame.size.height + 5), cell.frame.origin.y, cell.frame.size.height, cell.frame.size.height);
    [button setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    return cell;
}

- (IBAction)recordStopButton:(UIButton *)sender {
    if (buttonRecordPressed == NO) {
        [sender setBackgroundImage:_buttonStop forState:UIControlStateNormal];
        buttonRecordPressed = YES;
    } else {
        [sender setBackgroundImage:_buttonRecord forState:UIControlStateNormal];
        buttonRecordPressed = NO;
    }
}

- (IBAction)playPauseButton:(UIButton *)sender {
    if (buttonPlayPressed == NO) {
        [sender setBackgroundImage:_buttonPause forState:UIControlStateNormal];
        buttonPlayPressed = YES;
    } else {
        [sender setBackgroundImage:_buttonPlay forState:UIControlStateNormal];
        buttonPlayPressed = NO;
    }
}




@end


