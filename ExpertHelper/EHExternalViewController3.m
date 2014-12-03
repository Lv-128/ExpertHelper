//
//  EHExternalViewController3.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHExternalViewController3.h"

@interface EHExternalViewController3 ()

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableForRecords;
@property (copy, nonatomic) NSArray *arrayOfRecords;

@property (nonatomic) BOOL recording;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

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

    [_commentTextView.layer setBorderColor:[[UIColor blueColor] CGColor]];
     _commentTextView.layer.borderWidth = 2.0f;
    _commentTextView.layer.cornerRadius = 20;
    _commentTextView.clipsToBounds = YES;
    
    [_tableForRecords.layer setBorderColor:[[UIColor blueColor] CGColor]];
    _tableForRecords.layer.borderWidth = 2.0f;
    _tableForRecords.layer.cornerRadius = 20;
    _tableForRecords.clipsToBounds = YES;

    _arrayOfRecords =[[NSArray alloc] initWithObjects:@"record 1", @"record 2", @"record 3", nil];
    
    _recording = true;
    
    [_recordButton  setImage:[UIImage imageNamed:@"startRecord1.png"] forState:UIControlStateNormal];

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
    static NSString *cellIdentifier = @"RecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _arrayOfRecords[indexPath.row];
    
    return cell;
}

- (IBAction)record:(id)sender {
    if(_recording == true) {
        _recording = false;
        [sender  setImage:[UIImage imageNamed:@"stopRecord.png"] forState:UIControlStateNormal];
    }
    else {
        _recording = true;
        [sender  setImage:[UIImage imageNamed:@"startRecord1.png"] forState:UIControlStateNormal];
    }
    
}



@end
