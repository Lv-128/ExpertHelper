//
//  EHProfilesViewController.m
//  ExpertHelper
//
//  Created by Taras Koval on 11/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHProfilesViewController.h"
#import "EHProfilesTableViewCell.h"
#import "EHSkillLevelPopup.h"

@interface EHProfilesViewController ()<EHSkillLevelPopupDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSections;
@property (nonatomic, strong) NSArray *sectionContent;

@end

@implementation EHProfilesViewController
@synthesize message2;

- (void)skillLevelPopup:(EHSkillLevelPopup *)popup
         didSelectLevel:(EHSkillLevel)level {
}

- (void)skillLevelPopupDidSelectComment:(EHSkillLevelPopup *)popup {
    UIViewController *push2 = [[UIViewController alloc]init];
    [[self navigationController]pushViewController:push2 animated:YES];
}

- (void)viewDidLoad
{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableSections = @[ @"Programming languages", @"Tech. Domains", @"Skill" ];
    self.sectionContent = @[ @[ @"C", @"C++", @"C#", @"Objective-C" ],
                             @[ @"Multithreading", @"Web", @"Audio" ],
                             @[ @"Core", @"Desktop", @"Web", @"DB", @"BI", @"RIA", @"Multimedia", @"Mobile", @"Embedded" ] ];
    
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
    return [self.tableSections count];
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionContent[section] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create custom view to display section header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 18.0)];
    
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width / 3.0, 18.0)];
    [labelLeft setFont:[UIFont boldSystemFontOfSize:14]];
    [labelLeft setTextAlignment:NSTextAlignmentCenter];
    UILabel *labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 3.0, 0.0, tableView.frame.size.width / 3.0, 18.0)];
    [labelMiddle setTextAlignment:NSTextAlignmentCenter];
    [labelMiddle setFont:[UIFont boldSystemFontOfSize:14]];
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width * 0.667, 0.0, tableView.frame.size.width / 3.0, 18.0)];
    [labelRight setFont:[UIFont boldSystemFontOfSize:14]];
    [labelRight setTextAlignment:NSTextAlignmentCenter];
    
    labelLeft.text = [self.tableSections objectAtIndex:section];
    labelMiddle.text = @"Required";
    labelRight.text = @"Estimate";
    
    [view addSubview:labelLeft];
    [view addSubview:labelMiddle];
    [view addSubview:labelRight];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProfileCell";
    
    NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    
    EHProfilesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[EHProfilesTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.leftLabel.text = [listData objectAtIndex:row];
    [cell.leftLabel.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.leftLabel.layer setBorderWidth:1.0];
    [cell.middleLabel.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.middleLabel.layer setBorderWidth:1.0];
    [cell.rightLabel.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.rightLabel.layer setBorderWidth:1.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    NSUInteger row = [indexPath row];
    NSString *rowValue = [listData objectAtIndex:row];
    
    NSString *message = [[NSString alloc] initWithString:rowValue];
    message2 = message;
    [_delegate EHProfilesViewControllerDelegate:self  returnMessage:message2];
    
    
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
    popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
    popup.alpha = 0;
    popup.titleLabel.text = message;
    [self.view addSubview:popup];
    
    [UIView animateWithDuration:0.5 animations:^{
        popup.alpha = 1;
        popup.transform = CGAffineTransformMakeScale(1, 1);
    }];

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"You selected"
                          message:message delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
