//
//  EHListOfRecruiters.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 12/4/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHListOfRecruiters.h"
#import "EHListOfRecruitersCell.h"

@interface EHListOfRecruiters ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *recruitersArray;

@end

@implementation EHListOfRecruiters

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
    _recruitersArray = [[NSArray alloc] initWithObjects:@"recruiter 1", @"recruiter 2", @"recruiter 3", @"recruiter 4", @"recruiter 5", nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return _recruitersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"recruiterCell";
    EHListOfRecruitersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[EHListOfRecruitersCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
//    NSUInteger row = [indexPath row];
//    
//    cell.candidateName.text = [_namesArray objectAtIndex:row];
//    cell.passLabel.text = @"Pass:";
//    
//    [cell.checkButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
//    cell.checkButton.tag = indexPath.row;
//    [cell.checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.openPopUpButton setTitle:@"Select Score" forState:UIControlStateNormal];
//    cell.openPopUpButton.layer.cornerRadius = 20;//half of the width
//    cell.openPopUpButton.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.openPopUpButton.layer.borderWidth = 2.0f;
//    
//    [cell.openPopUpButton addTarget:self action:@selector(openPopUpClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.candidateImage setImage:[UIImage imageNamed:@"smile.png"] forState:UIControlStateNormal];
//    [cell.candidateImage addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
//    
    return cell;
}
@end
