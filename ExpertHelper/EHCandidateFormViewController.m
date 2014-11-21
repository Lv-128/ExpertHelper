//
//  EHCandidateFormViewController.m
//  ExpertHelper
//
//  Created by alena on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHCandidateFormViewController.h"
#import "EHPopoverViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "EHAppDelegate.h"

@interface EHCandidateFormViewController ()
@property (nonatomic, strong) EHPopoverViewController *popController;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@end

@implementation EHCandidateFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(id) init
{
    self = [super init];
    if (self) {
        _nameOfCandidate = @"Name : ";
        _lastnameOfCandidate = @"Last Name: ";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //_labelNameOfCandidate.text  = @"Name : ";
    //_labelNameOfCandidate.text = [_labelNameOfCandidate.text stringByAppendingString:[_nameOfCandidate stringByAppendingString:[@" "stringByAppendingString:_lastnameOfCandidate]]];
    _firstName = @"Maxym";
    _lastName = @"Ivanov";
    // Do any additional setup after loading the view.
}

- (IBAction)facebookButton:(id)sender {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        //[FBSession.activeSession closeAndClearTokenInformation];
        _popController = [[EHPopoverViewController alloc] initWithNibName:@"EHPopoverViewController" bundle:nil];
        //_popController.delegate = self;
        
        _popController.firstName = self.firstName;
        _popController.lastName = self.lastName;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:_popController];
        self.popover.popoverContentSize = CGSizeMake(400.0, 400.0);
        [self.popover presentPopoverFromRect:[(UIButton *)sender frame]
                                      inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             EHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
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

@end
