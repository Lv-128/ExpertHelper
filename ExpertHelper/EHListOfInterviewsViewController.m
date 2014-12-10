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
#import "EHCandidateFormViewController.h"
#import "EHRecruiterViewController.h"
#import "EHITAViewController.h"
#import "EHEventsGetInfoParser.h"
#import <MessageUI/MessageUI.h>
#import "EHAppDelegate.h"
#import "EHInterviewViewCell.h"



//#define  INTERVIEWTYPE [NSMutableArray arrayWithObjects:@"None", @"IT Academy",@"Internal",@"External",nil]
enum {None,ITA, Internal,External};
@interface EHListOfInterviewsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@property (strong, nonatomic) InterviewAppointment *curInterview ;
@property (strong, nonatomic) UIActionSheet *actionSheetTypes;
@property (strong, nonatomic) UILabel *label;

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
   
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    // button HR
    UIImage* imageHR = [UIImage imageNamed:@"hr.png"];
    
    CGRect frameimg = CGRectMake(0, 0, 55, 55);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:imageHR forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(goToHR)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *butHR =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=butHR;
    ////////////
    
    /// left slide menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    
    
    //parser
    _interviewFromEventsParser = [[EHEventsGetInfoParser alloc]init];
    [self checkTheFirstLoad];

    
    
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
//
//- (void) checkTheFirstLoad
//{
//    if (!_notFirstLoad)
//    {
//        NSDate *today = [NSDate date];
//        
//        unsigned int  compon = NSYearCalendarUnit|  NSMonthCalendarUnit ;
//        
//        
//        NSInteger monthday = [[[NSCalendar currentCalendar] components: compon fromDate:today] month];
//        NSInteger yearday  =[[[NSCalendar currentCalendar] components: compon fromDate:today] year];
//        
//        
//        NSString * keyForDictionary = [MONTHS objectAtIndex:monthday - 1];
//        keyForDictionary = [keyForDictionary stringByAppendingString:[NSString stringWithFormat: @", %ld", (long)yearday]];
//        NSInteger curMonth = monthday - 1;
//        
//        
//        NSArray *dictionaryOfInterviews = _interviewFromEventsParser.sortAllInterviewsToDictionary;
//        if(dictionaryOfInterviews.count>0)
//        {
//            for (int i=0;i<dictionaryOfInterviews.count;i++)
//            {
//                if ([[dictionaryOfInterviews[i]  nameOfMonth] isEqualToString:keyForDictionary])
//                {
//                    curMonth = i;
//                    break;
//                }
//                
//            }
//            
//            self.sortedWeeks = [[dictionaryOfInterviews objectAtIndex:curMonth] weeks] ;
//        }
//        else
//        {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
//                                                              message:@"You have no interview - events this month"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles:nil];
//            [message show];
//            
//        }
//        
//    }
//}
//

- (void) goToHR
{
    EHRecruitersViewController *itaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruitersForm"];
    [self.navigationController pushViewController:itaViewController animated: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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

- (void)onStartButton:(UIButton *)button {
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    NSLog(@"%@", event);
}

- (void)onSkypeButton:(UIButton *)button {
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    NSLog(@"%@", event);
}

- (void)onMailButton:(UIButton *)button {
    NSIndexPath *indexPath = [self indexPathOfButton:button];
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    NSLog(@"%@", event);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EHInterviewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    [cell.startButton addTarget:self action:@selector(onStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.skypeView addTarget:self action:@selector(onSkypeButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mailButton addTarget:self action:@selector(onMailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    EHWeek *week = [self.sortedWeeks objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = week.interviews;
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    UILabel *labelType = (UILabel *) [cell viewWithTag: 100];
    UILabel *labelDate = (UILabel *) [cell viewWithTag: 101];
    UILabel *labelLocation = (UILabel *) [cell viewWithTag: 102];
    UILabel *labelCandidate = (UILabel *) [cell viewWithTag: 103];
    UILabel *labelRecruiter = (UILabel *) [cell viewWithTag: 104];

    labelType.text = [NSString stringWithString:[INTERVIEWTYPE objectAtIndex:event.type.intValue]];
    labelDate.text = [@" "stringByAppendingString:[cellDateFormatter stringFromDate:event.startDate]];
    labelLocation.text = event.location == nil ? @"N/A" : event.location;

    labelCandidate.text = [@" " stringByAppendingString:event.idExternal.idCandidate.firstName];
    labelCandidate.text = [labelCandidate.text stringByAppendingString:[@" " stringByAppendingString:event.idExternal.idCandidate.lastName]];
    
    NSString *firstName = event.idRecruiter.firstName;
    NSString *lastName = event.idRecruiter.lastName;
    labelRecruiter.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName] ;
    
    NSArray *arrLabels = [NSArray arrayWithObjects:labelType,labelDate,labelLocation,labelCandidate,labelRecruiter,nil];
    for (UILabel*label in arrLabels)
    {
        //[label.layer  setCornerRadius:15.0f];
        //[label.layer setBorderWidth:2.0f];
        [label.layer setBorderColor:[UIColor grayColor].CGColor];
    }
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [cell.layer setCornerRadius:20.0f];
    cell.startButton.enabled = event.type.intValue != 0;
   
    return cell;
}

//
//- (void)showAllCandidates:(id)sender
//{
//    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
//    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
//    NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
//    
//    NSArray *eventsOnThisDay = [[self.sortedWeeks objectAtIndex:tappedRow.section] interviews];
//    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:tappedRow.row];
//    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
//    
//    for (int i = 0; i< event.nameAndLastNameOfCandidates.count; i++)
//    {
//        [array addObject: [event.nameAndLastNameOfCandidates objectAtIndex:i]];
//    }
//}


#pragma mark Work with Action sheets
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        if(buttonIndex != _actionSheetTypes.cancelButtonIndex)
        {
            //_curInterview.idType = [NSNumber numberWithInt:buttonIndex];
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
            CGRect  rect = CGRectMake([_label frame].origin.x - [_label frame].size.width / 3 , [_label frame].origin.y, [_label frame].size.width,  [_label frame].size.height) ;
           [_actionSheetTypes showFromRect:rect inView:curInterviewCell animated:YES ];//showFromRect:[label  frame] inView:self.view animated:YES];
        }
        else
            [_actionSheetTypes showInView:self.view];

}

- (void)goToInfo:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    
    if (tapGR.view.tag == 103)
    {
        CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
        
        NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
        
       // _curInterview = [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] objectAtIndex:tappedRow.row];
        
        NSArray * arr = [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] allObjects];
        InterviewAppointment * curInterview = [arr objectAtIndex:tappedRow.row];
        EHCandidateFormViewController *candidateForm = [self.storyboard instantiateViewControllerWithIdentifier:@"CandidateFormView"];
        
        
        if (![curInterview.idExternal.idCandidate.firstName isEqualToString: @"Unknown"])
        {
            candidateForm.nameOfCandidate = curInterview.idExternal.idCandidate.firstName;
            candidateForm.lastnameOfCandidate = curInterview.idExternal.idCandidate.lastName;
            
            candidateForm.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:candidateForm animated:YES ];
        }
    }
    if (tapGR.view.tag == 104)
    {
        CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
        
        NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
        

       // InterviewAppointment * curInterview = [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] objectAtIndex:tappedRow.row];
        NSArray * arr = [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] allObjects];
        InterviewAppointment * curInterview = [arr objectAtIndex:tappedRow.row];
        EHRecruiterViewController *recruiterViewForm = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruiterFormView"];
        recruiterViewForm.nameOfRecruiter = curInterview.idRecruiter.firstName;
        recruiterViewForm.lastnameOfRecruiter = curInterview.idRecruiter.lastName;
        
        recruiterViewForm.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:recruiterViewForm animated:YES];
    }
}

- (IBAction)goToITAForm:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
    

    if (tapGR.view.tag == 1000)
    {
        NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
      //  InterviewAppointment *curInterview =[[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] objectAtIndex:tappedRow.row];
        NSArray * arr = [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] allObjects];
        _curInterview = [arr objectAtIndex:tappedRow.row];
        if(_curInterview.type == [NSNumber numberWithInt:ITA])
        {
            EHITAViewController *itaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ITAForm"];
            [self.navigationController pushViewController:itaViewController animated: YES];
            
        }
        else
            if(_curInterview.type == [NSNumber numberWithInt:External])
            {
                EHITAViewController *externalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InternalForm"];
                [self.navigationController pushViewController:externalViewController animated: YES];
        }
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
  //  [mailController addAttachmentData:<#(NSData *)#> mimeType:<#(NSString *)#> fileName:<#(NSString *)#>]
    [self presentViewController:mailController animated:YES completion: nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendEmail:(id)sender event:(id)event
{
   
    [self sendEmailToAddress:@"elena.pyanyh@gmail.com"];
}


@end
