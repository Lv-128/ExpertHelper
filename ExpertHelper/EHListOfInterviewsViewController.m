//
//  EHListOfInterviewsViewController.m
//  ExpertHelper
//
//  Created by alena on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHListOfInterviewsViewController.h"
#import <EventKit/EventKit.h>

#import "EHEventsGetInfoParser.h"

#import "EHRecruiterViewController.h"
#import "EHITAViewController.h"
#import "EHEventsGetInfoParser.h"

#import "EHAppDelegate.h"
#import "EHInterviewViewCell.h"
#import "EHFacebookPopoverViewController.h"



//#define  INTERVIEWTYPE [NSMutableArray arrayWithObjects:@"None", @"IT Academy",@"Internal",@"External",nil]
enum {None,ITA, Internal,External};
@interface EHListOfInterviewsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate,
UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@property (strong, nonatomic) InterviewAppointment *curInterview ;
@property (strong, nonatomic) UIActionSheet *actionSheetTypes;
@property (strong, nonatomic) UILabel *label;
@property (nonatomic, strong) EHFacebookPopoverViewController *popController;
@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation EHListOfInterviewsViewController

@synthesize cellDateFormatter;
@synthesize sortedWeeks;
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    //set bar buttons
    [self setBarButtons];
    
    /// left slide menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //parser
    _interviewFromEventsParser = [[EHEventsGetInfoParser alloc]init];
    [self checkTheFirstLoad];
    
    
    
}
-(void)awakeFromNib
{
    
}
- (void)setBarButtons
{
    // menu
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    // button HR
    UIImage* imageHR = [UIImage imageNamed:@"hr.png"];
    
    CGRect frameimg = CGRectMake(0, 0, 55, 55);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:imageHR
                          forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(goToHR)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *butHR =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=butHR;
    
}

- (void) checkTheFirstLoad
{
    if (!_notFirstLoad)
    {
        NSDate *today = [NSDate date];
        
        unsigned int compon = NSYearCalendarUnit| NSMonthCalendarUnit ;
        
        
        NSInteger monthday = [[[NSCalendar currentCalendar] components: compon fromDate:today] month];
        NSInteger yearday =[[[NSCalendar currentCalendar] components: compon fromDate:today] year];
        
        
        NSString * keyForDictionary = [MONTHS objectAtIndex:monthday - 1];
        keyForDictionary = [keyForDictionary stringByAppendingString:[NSString stringWithFormat: @", %ld", (long)yearday]];
        
        
        NSArray *dictionaryOfInterviews = _interviewFromEventsParser.sortAllInterviewsToDictionary;
        NSInteger tempCurMonth = -1;
        
        
        for (int i=0;i<dictionaryOfInterviews.count;i++)
        {
            if ([[dictionaryOfInterviews[i] nameOfMonth] isEqualToString:keyForDictionary])
            {
                tempCurMonth = i;
                break;
            }
            
        }
        if(tempCurMonth != -1)
        {
            self.sortedWeeks = [[dictionaryOfInterviews objectAtIndex:tempCurMonth] weeks] ;
        }
        else
        {
            UIAlertView *message  = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                               message:@"You have no interview - events this month"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [message show];
            
        }
        
    }
    
}

#pragma mark SEGUES
- (void) goToHR
{
    EHRecruitersViewController *itaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruitersForm"];
    [self.navigationController pushViewController:itaViewController animated: YES];
}




- (IBAction)startInterview:(UIButton *)button
{
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    NSArray * arr = [[[sortedWeeks objectAtIndex:indexPath.section ] interviews] allObjects];
    _curInterview = [arr objectAtIndex:indexPath.row];
    if(_curInterview.type == [NSNumber numberWithInt:ITA])
    {
        EHITAViewController *itaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ITAForm"];
        [self.navigationController pushViewController:itaViewController animated: YES];
        
    }
    else
        if(_curInterview.type == [NSNumber numberWithInt:External])
        {
            EHExternalViewController *externalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExternalForm"];
            externalViewController.interview = [arr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:externalViewController animated: YES];
        }
}


#pragma mark Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sortedWeeks count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    EHWeek *weekOfMonth = [self.sortedWeeks objectAtIndex:section];
    return [weekOfMonth.interviews count];
}

- (NSIndexPath *)indexPathOfButton:(UIButton *)button {
    UIView *view = button.superview;
    while (![view isKindOfClass:[EHInterviewViewCell class]]) {
        view = view.superview;
    }
    return [_collectionView indexPathForCell:(UICollectionViewCell *)view];
}



- (void)onSkypeButton:(UIButton *)button {
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
  __unused  InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
 
        
        BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
        if(installed)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"skype:%@?call",event.idRecruiter.skypeAccount]]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/skype/skype"]];
        }
 
}

- (void)onMailButton:(UIButton *)button {
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    [self sendEmailToAddress:event.idRecruiter.email];
    
    
}
- (IBAction)facebookButton:(id)sender {
    NSIndexPath *indexPath = [self indexPathOfButton:sender];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    // If the session state is any of the two "open" states when the button is clicked
    NSLog(@"%d", FBSession.activeSession.state == FBSessionStateOpen);
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        //[FBSession.activeSession closeAndClearTokenInformation];
        _popController = [[EHFacebookPopoverViewController alloc] initWithNibName:@"EHFacebookPopoverViewController" bundle:nil];
        //_popController.delegate = self;
        
        _popController.firstName = event.idExternal.idCandidate.firstName;
        _popController.lastName = event.idExternal.idCandidate.lastName;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:_popController];
        self.popover.popoverContentSize = CGSizeMake(400.0, 400.0);
        [self searchUserWithFirstName:_popController.firstName lastName:_popController.lastName popover:self.popover];
        [self.popover presentPopoverFromRect: [(UIButton *)sender bounds]
                                      inView:sender
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

- (void)searchUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName popover:(UIPopoverController *)popover
{
    __block NSArray *links;
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/search?q=%@+%@&type=user", firstName, lastName]
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (error)
                              {
                                  NSLog(@"%@", [error description]);
                              }
                              else
                              {
                                  links = result[@"data"];
                                  if (links.count == 0)
                                  {
                                      [popover dismissPopoverAnimated:YES];
                                      [self showMessage:@"There aren't in facebook such people"];
                                  }
                                  
                                  
                              }
                          }];
}

- (void)showMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EHInterviewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    [cell.startButton addTarget:self action:@selector(startInterview:) forControlEvents:UIControlEventTouchUpInside];
    [cell.skypeButton addTarget:self action:@selector(onSkypeButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mailButton addTarget:self action:@selector(onMailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    cell.typeLabel.text = [NSString stringWithString:[INTERVIEWTYPE objectAtIndex:event.type.intValue]];
    cell.dateLabel.text = [cellDateFormatter stringFromDate:event.startDate];
    cell.addressLabel.text = event.location == nil ? @"N/A" : event.location;
    
    Candidate *candidate = event.idExternal.idCandidate;
    cell.candidateLabel.text = [NSString stringWithFormat:@"%@ %@" ,candidate.firstName, candidate.lastName];
    
    Recruiter *recruiter = event.idRecruiter;
    cell.recruiterLabel.text = [NSString stringWithFormat:@"%@ %@", recruiter.firstName, recruiter.lastName] ;
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.layer setCornerRadius:20.0f];
    
    cell.startButton.enabled = event.type.intValue != 0;
    
    UITapGestureRecognizer *gestureAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo:)];
    gestureAction.numberOfTapsRequired = 1;
    [gestureAction setDelegate:self];
    [cell.recruiterLabel addGestureRecognizer:gestureAction];
    
    gestureAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTypeOfInterview:)];
    [cell.typeLabel addGestureRecognizer:gestureAction];
    
    
    return cell;
}


#pragma mark Work with Action sheets
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex != _actionSheetTypes.cancelButtonIndex)
    {
        
        _label.text = [_actionSheetTypes buttonTitleAtIndex:buttonIndex];
        
        EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError * error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"eventId == %@",_curInterview.eventId];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[InterviewAppointment entityName]
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (InterviewAppointment *info in fetchedObjects) {
            info.type = [NSNumber numberWithInt:buttonIndex];
        }
        [_collectionView reloadData];
        
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
}


- (void)chooseTypeOfInterview:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
    NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
    
    EHWeek *week = [self.sortedWeeks objectAtIndex:tappedRow.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:tappedRow.row];
    
    _actionSheetTypes = [[UIActionSheet alloc] initWithTitle:@"Select type of interview:"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"None", @"IT Academy", @"Internal", @"External",nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UICollectionViewCell *curInterviewCell = [self.collectionView  cellForItemAtIndexPath:tappedRow];
        _label = (UILabel *)[curInterviewCell viewWithTag:100];
        _curInterview = event;
        CGRect  rect = CGRectMake([_label frame].origin.x - [_label frame].size.width / 3 ,
                                  [_label frame].origin.y,
                                  [_label frame].size.width,
                                  [_label frame].size.height) ;
        [_actionSheetTypes showFromRect:rect inView:curInterviewCell animated:YES ];
    }
    else
        [_actionSheetTypes showInView:self.view];
    
}

- (void)goToInfo:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    if (tapGR.view.tag == 104)
    {
        CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
        
        NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
        NSArray * arr = [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] allObjects];
        InterviewAppointment * curInterview = [arr objectAtIndex:tappedRow.row];
        EHRecruiterViewController *recruiterViewForm = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruiterFormView"];
        recruiterViewForm.recruiter = curInterview.idRecruiter;
        
        recruiterViewForm.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:recruiterViewForm animated:YES];
    }
}




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview == nil) {
            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        }
        
        UILabel *label = (UILabel *) [reusableview viewWithTag: 2000];//label of header
        
        NSString *dateRepresentingThisDay = [[self.sortedWeeks objectAtIndex:indexPath.section]nameOfWeek];
        label.text = dateRepresentingThisDay;
        return reusableview;
    }
    return nil;
}
#pragma mark Send Email To Recruiter
- (void)sendEmailToAddress:(NSString*)address
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    
    NSArray *addressArray = [[NSArray alloc]initWithObjects:address, nil];
    [mailController setMessageBody:@"Print message here!" isHTML:NO];
    [mailController setToRecipients:addressArray];
    [mailController setSubject:@""];
    [mailController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:mailController animated:YES completion: nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
