//
//  EHITAViewController.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHITAViewController.h"
#import "EHITAViewControllerCell.h"

@interface EHITAViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) NSArray *sectionContent;



@end

@implementation EHITAViewController



- (void)viewDidLoad
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   [super viewDidLoad];
	
    
    
    
    
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
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create custom view to display section header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 18.0)];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width / 4.0, 18.0)];
    
    [labelName setFont:[UIFont boldSystemFontOfSize:14]];
    [labelName setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *labelPass = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 4.0, 0.0, tableView.frame.size.width / 4.0, 18.0)];
    
    [labelPass setTextAlignment:NSTextAlignmentCenter];
    [labelPass setFont:[UIFont boldSystemFontOfSize:14]];
    
    UILabel *labelComment = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 4.0 * 2.1, 0.0, tableView.frame.size.width / 4.0, 18.0)];
    
    [labelComment setFont:[UIFont boldSystemFontOfSize:14]];
    [labelComment setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *labelScore = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 4.0 * 3, 0.0, tableView.frame.size.width / 4.0, 18.0)];
    
    [labelScore setFont:[UIFont boldSystemFontOfSize:14]];
    [labelScore setTextAlignment:NSTextAlignmentCenter];
    
    labelName.text = @"Name";
    labelPass.text = @"Pass";
    labelComment.text = @"Comment";
    labelScore.text = @"Score";
    
    
    [view addSubview:labelName];
    [view addSubview:labelPass];
    [view addSubview:labelComment];
    [view addSubview:labelScore];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ItaCell";
    
 //   NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    
 EHITAViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[EHITAViewControllerCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
  //  NSUInteger row = [indexPath row];
    
    //cell.leftLabel.text = [listData objectAtIndex:row];
  

    
    cell.labelName.tag = indexPath.row;

	cell.labelName.userInteractionEnabled = YES;

    
    [cell.labelName.layer setBorderWidth:1.0];
    [cell.labelName.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    
    [cell.labelPass.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.labelPass.layer setBorderWidth:1.0];
    
    [cell.labelComment.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.labelComment.layer setBorderWidth:1.0];
    
    [cell.labelScore.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.labelScore.layer setBorderWidth:1.0];

    return cell;
}

int row;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    row = indexPath.row;
    
    EHITAViewControllerCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    UITapGestureRecognizer * single = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singletap:)];

    [cell.labelName addGestureRecognizer:single];
    single.numberOfTapsRequired = 1;
  
}

-(void) singletap:(id)sender
{
    NSLog(@"single tap");
  }


/*

-(void)pressLabel {
    _pressLabel1.text = @"pressed";
}
*/
/*
- (IBAction)viewWasTouched:(UITapGestureRecognizer *)sender
{
  if (sender.numberOfTouches == 1) {
        CGPoint touchPoint = [sender locationOfTouch:0 inView:self.pressLabel1];
        CGFloat touchX = touchPoint.x;
        CGFloat touchY = touchPoint.y;
        // is the touch in the bounds of the touchLabel?
        if (touchX >= 0 && touchY >= 0) {
            if (touchX <= self.pressLabel1.bounds.size.width && touchY <= self.pressLabel1.bounds.size.height) {
                [self performSelector:@selector(pressLabel)];
            }
        }
    }
}*/



@end
