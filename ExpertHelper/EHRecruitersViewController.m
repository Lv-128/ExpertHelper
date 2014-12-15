//
//  EHRecruitersViewController.m
//  ExpertHelper
//
//  Created by alena on 12/5/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHRecruitersViewController.h"
#import "EHListOfRecruitersCell.h"
#import <MessageUI/MessageUI.h>


@interface EHRecruitersViewController ()<MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate>{
    Reachability *internetReachable;
}
@end

@implementation EHRecruitersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _recruitersArray = [[NSArray alloc] init];
    EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    [self getAllRecruitersFromDB];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    
    cell.nameLabel.text = [NSString stringWithFormat: @" %@ %@ ", [_recruitersArray[indexPath.row] firstName],
                           [_recruitersArray[indexPath.row] lastName]];
    cell.skypeLabel.text = [_recruitersArray[indexPath.row] skypeAccount];
    cell.recruiterEmail.text = [_recruitersArray[indexPath.row] email];
    if ([_recruitersArray[indexPath.row] photoUrl] == nil)
    {
        
        [cell.picture setImage:[UIImage imageNamed:@"contact.png"]];
        
        
    }
    else
    {
        EHCheckNetworkConnection * checkConnection = [[EHCheckNetworkConnection alloc]
                                                      initWithHost : [_recruitersArray[indexPath.row] photoUrl]];
        if (checkConnection.internetActive == YES)
        {
            NSURL *imgURL = [NSURL URLWithString:[_recruitersArray[indexPath.row] photoUrl]];
            
            NSData *imgdata=[[NSData alloc]initWithContentsOfURL:imgURL];
            
            UIImage *image=[[UIImage alloc]initWithData:imgdata];
            
            [cell.picture setImage:image];
        }
        else{
            [cell.picture setImage:[UIImage imageNamed:@"contact.png"]];
        }
        
    }
    cell.skypeBut.tag = indexPath.row;
    [cell.skypeBut addTarget:self action:@selector(skypeMe:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mailBut addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    
//    UITapGestureRecognizer *sendEmailTp = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                  action:@selector(sendEmail:)];
//    [sendEmailTp setDelegate:self];
//    [cell.mailBut addGestureRecognizer:sendEmailTp];
//    sendEmailTp.numberOfTapsRequired = 1;
//    
//    UITapGestureRecognizer *sendEmailTp2 = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                   action:@selector(skypeMe:)];
//    [sendEmailTp2 setDelegate:self];
//    
//    [cell.skypeBut addGestureRecognizer:sendEmailTp2];
//    sendEmailTp2.numberOfTapsRequired = 1;
    
    return cell;
}



- (void)getAllRecruitersFromDB
{
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Recruiter entityName]
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    _recruitersArray= [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (_recruitersArray.count == 0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"There is no recruiters in DB yet!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
}





//- (void)onSkypeButton:(UIButton *)button {
//    NSIndexPath *indexPath = [self indexPathOfButton:button];
//    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
//    NSArray *eventsOnThisDay = week.interviews;
//    __unused  InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
//    
//    
//    
//    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
//    if(installed)
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"skype:%@?call",event.idRecruiter.skypeAccount]]];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/skype/skype"]];
//    }
//    
//}

- (IBAction)sendEmailMsg:(NSString*)address
{
    
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    
    NSArray *addressArray = [[NSArray alloc]initWithObjects:address, nil];
    [mailController setMessageBody:@"Print message here!" isHTML:NO];
    [mailController setToRecipients:addressArray];
    [mailController setSubject:@""];
    [mailController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    //  [mailController addAttachmentData:<#(NSData *)#> mimeType:<#(NSString *)#> fileName:<#(NSString *)#>]
    [self presentViewController:mailController animated:YES completion: nil];
    
    
    
}


- (void)mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSIndexPath *)indexPathOfButton:(UIButton *)button {
    UIView *view = button.superview;
    while (![view isKindOfClass:[EHListOfRecruitersCell class]]) {
        view = view.superview;
    }
    return [_tableView indexPathForCell:(UITableViewCell *)view];
}
- (void)sendEmail:(UIButton *)button {
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    
    EHListOfRecruitersCell *cell = (EHListOfRecruitersCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    [self sendEmailMsg:cell.recruiterEmail.text];
    
    
}

- (void)skypeMe:(UIButton *)button {
    UIButton *btn = (UIButton *)button;
    int index = [btn tag];
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:index];
    
    
    EHListOfRecruitersCell *cell = (EHListOfRecruitersCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
    if(installed)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"skype:%@?call",cell.skypeLabel.text]]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/skype/skype"]];
    }
    
}
/*- (IBAction)sendEmail:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.tableView];
    
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: touchLocation];
    
    EHListOfRecruitersCell *cell = (EHListOfRecruitersCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    [self sendEmailMsg:cell.recruiterEmail.text];}*/

@end
