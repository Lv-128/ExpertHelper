//
//  EHCommentViewController.m
//  ExpertHelper
//
//  Created by Katolyk S. on 11/21/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHCommentViewController.h"
#import "EHSkillsLevelViewController.h"
#import "EHCommentCell.h"


@interface EHCommentViewController () <UITableViewDelegate, UITableViewDataSource, EHSkillsLevelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSections;
@property (nonatomic, strong) NSArray *sectionContent;

@end

@implementation EHCommentViewController

- (void)skillsLevelDelegate:(EHSkillsLevelViewController *)popup returnSkillsArray:(NSArray *)skillArray{
    
    self.skillsLabel.text = @"";
    
    for (int x=0; x<skillArray.count; x++)
        self.skillsLabel.text = [self.skillsLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@  ",[skillArray objectAtIndex:x]]];
    
    self.tableSections = skillArray;
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sectionContent = @[ @[ @"Java1", @"Java2" ],
                             @[ @"C++1", @"C++2", ],
                             @[ @"C#1", @"C#2", ] ];
}


//dont touching this
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"skillsCell"])
    {
        EHSkillsLevelViewController * skillsLevelPopover = [segue destinationViewController];
        skillsLevelPopover.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableSections count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, tableView.frame.size.width - 10, 18.0)];
    
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width * 0.3, 0.0, tableView.frame.size.width / 3.0, 18.0)];
    [labelLeft setFont:[UIFont boldSystemFontOfSize:14]];
    [labelLeft setTextAlignment:NSTextAlignmentCenter];
    
    labelLeft.text = [self.tableSections objectAtIndex:section];
    
    [view addSubview:labelLeft];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionContent[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    EHCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[EHCommentCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [listData objectAtIndex:row];
    [cell.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.layer setBorderWidth:1.0];
    return cell;
}

@end
