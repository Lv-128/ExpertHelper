//
//  EHRecruiterViewController.m
//  ExpertHelper
//
//  Created by alena on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHRecruiterViewController.h"
#import "EHAppDelegate.h"
@interface EHRecruiterViewController ()

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
    [super viewDidLoad];
    
    _photoRecruiter.layer.cornerRadius = 10;
    _panel.layer.cornerRadius = 10;
    _panel.layer.borderColor = [UIColor grayColor].CGColor;
    _panel.layer.borderWidth = 2;
  
    
    _labelNameOfRecruiter.text = [NSString stringWithFormat:@"Name: %@ %@", _recruiter.firstName, _recruiter.lastName];
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
        NSLog(@"%@",imgURL);
        
        [_photoRecruiter setImage:image];
    }
        
    }
    else
     if (_recruiter.photoUrl == nil || checkConnection.internetActive == NO){
        [_photoRecruiter setImage:[UIImage imageNamed:@"contact.png"]];
      
    }
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
    
    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
    if(installed)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"skype:echo123?call"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/skype/skype"]];
    }
}
@end
