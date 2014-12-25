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


@interface EHRecruitersViewController () <MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate>
{
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
    cell.tag = indexPath.row;
    cell.nameLabel.text = [NSString stringWithFormat: @" %@ %@ ",
                           [_recruitersArray[indexPath.row] firstName],
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
    NSLog(@"%@", NSStringFromCGRect(cell.frame));
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
                                                          message:@"There are no recruiters in DB yet!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (IBAction)sendEmailMsg:(NSString*)address
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    
    NSArray *addressArray;
    
    if (![address isEqualToString:@"unknown@unknown.com"])
    {
        (addressArray = [[NSArray alloc]initWithObjects:address, nil]);
        [mailController setMessageBody:@"Print message here!" isHTML:NO];
        [mailController setToRecipients:addressArray];
        [mailController setSubject:@""];
        [mailController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:mailController animated:YES completion: nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Sorry, can't find recruiter's email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController *) controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSIndexPath *)indexPathOfButton:(UIButton *)button {
    UIView *view = button.superview;
    while (![view isKindOfClass:[EHListOfRecruitersCell class]]) {
        view = view.superview;
    }
    return [_tableView indexPathForCell:(UITableViewCell *)view];
}

- (IBAction)sendEmail:(id)sender {
    UIButton *button = sender;
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHListOfRecruitersCell *cell = (EHListOfRecruitersCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [self sendEmailMsg:cell.recruiterEmail.text];
    
}

- (IBAction)skypeMe:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = [self indexPathOfButton:btn];
    
    EHListOfRecruitersCell *cell = (EHListOfRecruitersCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    if(![cell.skypeLabel.text isEqualToString:@"echo123"])
    {
        BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
        if(installed)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"skype:%@?call",
                                                                             cell.skypeLabel.text]]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/skype/skype"]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Sorry, can't find recruiter's skype"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
