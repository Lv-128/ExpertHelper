//
//  EHListOfInterviewsViewController.m
//  ExpertHelper
//
//  Created by alena on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "EHAppDelegate.h"
#import "EHRecruiterViewController.h"
#import "EHMapViewController.h"

enum {
    None,
    ITA,
    Internal,
    External };

@interface EHListOfInterviewsViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
UIGestureRecognizerDelegate,
UITextFieldDelegate,
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonHR;

@property (nonatomic, strong) NSDateFormatter *cellDateFormatter;
@property (nonatomic, strong) InterviewAppointment *curInterview;
@property (nonatomic, strong) EHMapViewController *mapViewController;
@property (nonatomic, strong) EHRecruiterViewController *recruitersController;
@property (nonatomic, strong) UIActionSheet *actionSheetTypes;
@property (nonatomic, strong) UILabel *label;
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
    [self.cellDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    //set bar buttons
    [self setBarButtons];
    
    /// left slide menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //parser
    interviewFromEventsParser = [[EHEventsGetInfoParser alloc]init];
    [self checkTheFirstLoad];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.recruteirPopover dismissPopoverAnimated:YES];
}

- (void)setBarButtons
{
    // menu
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    // button HR
    
    UIBarButtonItem *butHR =[[UIBarButtonItem alloc] initWithTitle:@"HR"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(goToHR)];
    self.navigationItem.rightBarButtonItem = butHR;
}

- (void)checkTheFirstLoad
{
    if (!_notFirstLoad)
    {
        [((EHEventsGetInfoParser *)interviewFromEventsParser).calEventParser checkEventStoreAccessForCalendar];
        [interviewFromEventsParser sortAllInterviewsToDictionary];
        
        NSDate *today = [NSDate date];
        
        unsigned int compon = NSYearCalendarUnit| NSMonthCalendarUnit ;
        
        NSInteger monthday = [[[NSCalendar currentCalendar] components:compon fromDate:today] month];
        NSInteger yearday = [[[NSCalendar currentCalendar] components:compon fromDate:today] year];
        
        NSString *keyForDictionary = [MONTHS objectAtIndex:monthday - 1];
        keyForDictionary = [keyForDictionary stringByAppendingString:[NSString stringWithFormat:@", %ld", (long)yearday]];
        
        NSArray *dictionaryOfInterviews = ((EHEventsGetInfoParser *)interviewFromEventsParser).sortAllInterviewsToDictionary;
        NSInteger tempCurMonth = -1;
        
        for (int i = 0; i < dictionaryOfInterviews.count; i++)
            if ([[dictionaryOfInterviews[i] nameOfMonth] isEqualToString:keyForDictionary])
            {
                tempCurMonth = i;
                break;
            }
        
        if(tempCurMonth != -1)
            self.sortedWeeks = [[dictionaryOfInterviews objectAtIndex:tempCurMonth] weeks];
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                              message:@"You have no interview - events this month"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
}

#pragma mark - SEGUES

- (void)goToHR
{
    EHRecruitersViewController *itaViewController = [self.storyboard instantiateViewControllerWithIdentifier:
                                                     @"RecruitersForm"];
    [self.navigationController pushViewController:itaViewController
                                         animated:YES];
}

- (void)startInterview:(UIButton *)button
{
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    NSArray *arr = [[[sortedWeeks objectAtIndex:indexPath.section ] interviews] allObjects];
    _curInterview = [arr objectAtIndex:indexPath.row];
    if (_curInterview.type == [NSNumber numberWithInt:ITA])
    {
        EHITAViewController *itaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ITAForm"];
        [self.navigationController pushViewController:itaViewController animated:YES];
    }
    else
        if (_curInterview.type == [NSNumber numberWithInt:External])
        {
            EHExternalViewController *externalViewController = [self.storyboard
                                                                instantiateViewControllerWithIdentifier:@"ExternalForm"];
            externalViewController.interview = [arr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:externalViewController animated:YES];
        }
}

- (void)goToInfo:(id)sender
{
    [self.collectionView reloadData];
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
    NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
    
    EHInterviewViewCell *cell = (EHInterviewViewCell *)[self.collectionView cellForItemAtIndexPath:tappedRow];
    NSArray *arr = [[[sortedWeeks objectAtIndex:tappedRow.section] interviews] allObjects];
    InterviewAppointment *curInterview = [arr objectAtIndex:tappedRow.row];
    
    self.recruitersController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruiterFormView"];
    self.recruteirPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruiterFormView"];
    
    self.recruitersController.recruiter = curInterview.idRecruiter;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        float width;
        (self.view.frame.size.width > self.view.frame.size.height) ? (width = self.view.frame.size.height) : (width = self.view.frame.size.width);
        [self.recruitersController.view setFrame:CGRectMake(self.recruitersController.view.frame.origin.x, self.recruitersController.view.frame.origin.y, width, 550)];
        
        self.recruteirPopover = [[UIPopoverController alloc] initWithContentViewController:self.recruitersController];
        self.recruteirPopover.popoverContentSize = CGSizeMake(width, 550.0);
        
        CGRect rect = CGRectMake(cell.frame.origin.x + 50, cell.frame.origin.y + 100, 10, 10);
        
        [self.recruteirPopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionLeft
                                             animated:YES];
    } else
        [self.navigationController pushViewController:self.recruitersController animated:YES];
}

- (void)mapPosition:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
    NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
    
    NSArray *arr = [[[sortedWeeks objectAtIndex:tappedRow.section] interviews] allObjects];
    InterviewAppointment *curInterview = [arr objectAtIndex:tappedRow.row];
    
    self.mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    
    _mapViewController.interview = [arr objectAtIndex:tappedRow.row];
    _mapViewController.location = curInterview.location;
    
    [self.navigationController pushViewController:self.mapViewController animated:YES];
}

#pragma mark - Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sortedWeeks count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    EHWeek *weekOfMonth = [self.sortedWeeks objectAtIndex:section];
    return [weekOfMonth.interviews count];
}

- (NSIndexPath *)indexPathOfButton:(UIButton *)button
{
    UIView *view = button.superview;
    while (![view isKindOfClass:[EHInterviewViewCell class]])
        view = view.superview;
    
    return [_collectionView indexPathForCell:(UICollectionViewCell *)view];
}

- (NSIndexPath *)indexPathOfTextField:(UITextField *)textField
{
    UIView *view = textField.superview;
    while (![view isKindOfClass:[EHInterviewViewCell class]])
        view = view.superview;
    
    return [_collectionView indexPathForCell:(UICollectionViewCell *)view];
}

- (void)onSkypeButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    __unused InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    if(![event.idRecruiter.skypeAccount isEqualToString:@"echo123"])
    {
        BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
        if(installed)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        [NSString stringWithFormat:@"skype:%@?call",
                                                         event.idRecruiter.skypeAccount]]];
        }
        else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/skype/skype"]];
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

- (void)onMailButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    [self sendEmailToAddress:event.idRecruiter.email];
}

- (IBAction)facebookButton:(id)sender
{
    NSIndexPath *indexPath = [self indexPathOfButton:sender];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        //[FBSession.activeSession closeAndClearTokenInformation];
        _popController = [[EHFacebookPopoverViewController alloc] initWithNibName:@"EHFacebookPopoverViewController" bundle:nil];
        //_popController.delegate = self;
        
        _popController.firstName = event.idExternal.idCandidate.firstName;
        _popController.lastName = event.idExternal.idCandidate.lastName;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:_popController];
            self.popover.popoverContentSize = CGSizeMake(400.0, 400.0);
            [self searchUserWithFirstName:_popController.firstName lastName:_popController.lastName popover:self.popover];
            [self.popover presentPopoverFromRect:[(UIButton *)sender bounds]
                                          inView:sender
                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                        animated:YES];
        }
        else
            [self.navigationController pushViewController:_popController animated:YES];
        
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
                                  NSLog(@"%@", [error description]);
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
    InterviewAppointment *event = [week.interviews objectAtIndex:indexPath.row];
    
    cell.groupName.delegate = self;
    
    cell.typeLabel.text = [NSString stringWithString:[INTERVIEWTYPE objectAtIndex:event.type.intValue]];
    cell.dateLabel.text = [cellDateFormatter stringFromDate:event.startDate];
    cell.addressLabel.text = event.location == nil ? @"N/A" : event.location;
    
    if (event.type.intValue == 1) {
        cell.groupsOrCandidate.text = @"Group :";
        cell.groupName.hidden = NO;
        cell.candidateLabel.hidden = YES;
        ITAInterview *ITAinterview = event.idITAInterview;
        cell.groupName.text = ITAinterview.itaGroupName == nil ? @"" : [NSString stringWithFormat:@"%@", ITAinterview.itaGroupName];
    } else {
        cell.groupsOrCandidate.text = @"Candidate :";
        cell.groupName.hidden = YES;
        cell.candidateLabel.hidden = NO;
        Candidate *candidate = event.idExternal.idCandidate;
        cell.candidateLabel.text = [NSString stringWithFormat:@"%@ %@", candidate.firstName, candidate.lastName];
    }
    
    Recruiter *recruiter = event.idRecruiter;
    cell.recruiterLabel.text = [NSString stringWithFormat:@"%@ %@", recruiter.firstName, recruiter.lastName];
    
    [cell.layer setBorderWidth:0.7f];
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    
    cell.startButton.enabled = event.type.intValue != 0;
    
    UITapGestureRecognizer *gestureAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo:)];
    gestureAction.numberOfTapsRequired = 1;
    [gestureAction setDelegate:self];
    [cell.recruiterLabel addGestureRecognizer:gestureAction];
    
    UITapGestureRecognizer *gestureAction2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTypeOfInterview:)];
    gestureAction2.numberOfTapsRequired = 1;
    [gestureAction2 setDelegate:self];
    [cell.typeLabel addGestureRecognizer:gestureAction2];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapPosition:)];
    [cell.addressLabel addGestureRecognizer:gesture];
    cell.addressLabel.userInteractionEnabled = YES;
    
    return cell;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSIndexPath *index = [self indexPathOfTextField:textField];
    
    EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error = nil;
   
    EHWeek *week = [self.sortedWeeks objectAtIndex:index.section];
    InterviewAppointment *event = [week.interviews objectAtIndex:index.row];
    
    ITAInterview *ITAi = event.idITAInterview;
    
    ITAi.itaGroupName = textField.text;
    NSLog(@"%@", ITAi);
    
    [_collectionView reloadData];
    
    if (![context save:&error])
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:[ITAInterview entityName]
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
   
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
//    for (ITAInterview *info in fetchedObjects)
//        NSLog(info.itaGroupName);

    return YES;
}

#pragma mark - Work with Action sheets

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != _actionSheetTypes.cancelButtonIndex)
    {
        _label.text = [_actionSheetTypes buttonTitleAtIndex:buttonIndex];
        
        EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId == %@", _curInterview.eventId];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[InterviewAppointment entityName]
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        for (InterviewAppointment *info in fetchedObjects)
            info.type = [NSNumber numberWithInt:(int)buttonIndex];
        
        [_collectionView reloadData];
        
        if (![context save:&error])
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)chooseTypeOfInterview:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
    NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
    
    EHWeek *week = [self.sortedWeeks objectAtIndex:tappedRow.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:tappedRow.row];
    
    _actionSheetTypes = [[UIActionSheet alloc] initWithTitle:@"Select type of interview:"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"None", @"IT Academy", @"Internal", @"External", nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UICollectionViewCell *curInterviewCell = [self.collectionView cellForItemAtIndexPath:tappedRow];
        _label = (UILabel *)[curInterviewCell viewWithTag:100];
        _curInterview = event;
        CGRect rect = CGRectMake([_label frame].origin.x - [_label frame].size.width / 3,
                                 [_label frame].origin.y,
                                 [_label frame].size.width,
                                 [_label frame].size.height);
        [_actionSheetTypes showFromRect:rect inView:curInterviewCell animated:YES];
    }
    else
        [_actionSheetTypes showInView:self.view];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *reusableview =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:@"HeaderView"
                                                  forIndexPath:indexPath];
        
        UILabel *label = (UILabel *)[reusableview viewWithTag:2000];//label in header
        
        NSString *dateRepresentingThisDay = [[self.sortedWeeks objectAtIndex:indexPath.section]nameOfWeek];
        label.text = dateRepresentingThisDay;
        return reusableview;
    }
    return nil;
}

#pragma mark - Send Email To Recruiter

- (void)sendEmailToAddress:(NSString *)address
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

- (void)mailComposeController:(MFMailComposeViewController *) controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
