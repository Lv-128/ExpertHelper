//
//  EHRecruiterViewController.m
//  ExpertHelper
//
//  Created by alena on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHRecruiterViewController.h"
#import "EHAppDelegate.h"

@interface EHRecruiterViewController ()  <MFMailComposeViewControllerDelegate>

@end

@implementation EHRecruiterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    _photoRecruiter.layer.masksToBounds = YES;
    _photoRecruiter.layer.cornerRadius = 10;
    _panel.layer.cornerRadius = 10;
    _panel.layer.borderColor = [UIColor grayColor].CGColor;
    _panel.layer.borderWidth = 2;
  
    
    _labelNameOfRecruiter.text = [NSString stringWithFormat:@"%@ %@", _recruiter.firstName, _recruiter.lastName];
    _emailRecruiter.text = _recruiter.email;
    _skypeRecruiter.text = _recruiter.skypeAccount;
    
    EHCheckNetworkConnection * checkConnection;
    if (_recruiter.photoUrl!= nil)
        {
            checkConnection = [[EHCheckNetworkConnection alloc] initWithHost : _recruiter.photoUrl];
            if (checkConnection.internetActive == YES)
                {
                    NSURL *imgURL = [NSURL URLWithString:_recruiter.photoUrl];
        
                    NSData *imgdata=[[NSData alloc]initWithContentsOfURL:imgURL];
        
                    UIImage *image=[[UIImage alloc]initWithData:imgdata];

                    [_photoRecruiter setImage:image];
                }
        }
        else
            if (_recruiter.photoUrl == nil || checkConnection.internetActive == NO){
                [_photoRecruiter setImage:[UIImage imageNamed:@"contact.png"]];
            }

    [super viewDidLoad];
}

#pragma mark Send Email To Recruiter
- (void)sendEmailToAddress:(NSString*)address
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    
    NSArray *addressArray;
    if(![address isEqualToString:@"unknown@unknown.com"])
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

- (void)mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)emailMe:(id)sender
{
    [self sendEmailToAddress:_recruiter.email];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//----------------------------— Skype implementation —----------------------------

- (IBAction)skypeMe:(id)sender {
  
    if(![_recruiter.skypeAccount isEqualToString:@"echo123"])
    {
        BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
        if(installed)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        [NSString stringWithFormat:@"skype:%@?call",
                                                         _recruiter.skypeAccount]]];
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
