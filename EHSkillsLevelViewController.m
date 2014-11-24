//
//  EHSkillsLevelViewController.m
//  ExpertHelper
//
//  Created by Katolyk S. on 11/21/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHSkillsLevelViewController.h"
#import "EHCommentViewController.h"

@interface EHSkillsLevelViewController ()

@end

@implementation EHSkillsLevelViewController

- (void)viewDidLoad
{
    self.skillArray = @[@"Java", @"C#", @"C++", @"Objective-C", @"HTML", @"CSS", @"JavaScript", @"Perl", @"PHP", @"Python", @"Ruby", @"SQL", @"Other"];
    [super viewDidLoad];
    self.selectedSkillArray = [[NSMutableArray alloc]init];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_delegate skillsLevelDelegate:self returnSkillsArray:self.selectedSkillArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_skillArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SkillsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _skillArray[indexPath.row];
    
    return cell;
}
- (void)viewDidAppear:(BOOL)animated
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *array = [_selectedSkillArray mutableCopy];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [array addObject:cell.textLabel.text];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        [array removeObject:cell.textLabel.text];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.selectedSkillArray = array;
}


@end
