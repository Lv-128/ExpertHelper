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


//#define  INTERVIEWTYPE [NSMutableArray arrayWithObjects:@"None", @"IT Academy",@"Internal",@"External",nil]
enum {None,ITA, Internal,External};
@interface EHListOfInterviewsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    NSArray *eventsOnThisDay = [[self.sortedWeeks objectAtIndex:indexPath.section] interviews];
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    
    UILabel *labelType = (UILabel *) [cell viewWithTag: 100];
    UILabel *labelDate = (UILabel *) [cell viewWithTag: 101];
    UILabel *labelLocation = (UILabel *) [cell viewWithTag: 102];
    UILabel *labelCandidate = (UILabel *) [cell viewWithTag: 103];
    UILabel *labelRecruiter = (UILabel *) [cell viewWithTag: 104];
    UIButton *butStart = (UIButton *) [cell viewWithTag: 1000];
    
    
    

    labelType.text = [NSString stringWithString:[INTERVIEWTYPE objectAtIndex:event.type.intValue]];
    labelDate.text = [@" "stringByAppendingString:[cellDateFormatter stringFromDate:event.startDate]];
    
    if (event.location == nil)
    {
        labelLocation.text = @" 1" ;
    }
    else
        labelLocation.text = [@" " stringByAppendingString:event.location];
    
   
    if (event.type == [NSNumber numberWithInt:External])
    {
        
        
        labelCandidate.text = [@" " stringByAppendingString:event.idExternal.idCandidate.firstName];
        labelCandidate.text = [labelCandidate.text stringByAppendingString:[@" " stringByAppendingString:event.idExternal.idCandidate.lastName]];
        UITapGestureRecognizer *goToInfoForm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo:)];
        [goToInfoForm setDelegate:self];
        [labelRecruiter addGestureRecognizer:goToInfoForm];
        [labelCandidate addGestureRecognizer:goToInfoForm];
        goToInfoForm.numberOfTapsRequired = 1;
    }
    else
    {

        

//        labelCandidate.text = @" many candidates";
//
//        UITapGestureRecognizer *goToInfoForm5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllCandidates: )];
//        [goToInfoForm5 setDelegate:self];
//        [labelCandidate addGestureRecognizer:goToInfoForm5];
//        goToInfoForm5.numberOfTapsRequired = 1;
    }
                      
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

    UITapGestureRecognizer *goToInfoForm2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo:)];
    [goToInfoForm2 setDelegate:self];
    [labelRecruiter addGestureRecognizer:goToInfoForm2];
    goToInfoForm2.numberOfTapsRequired = 1;
    
    

    
    UITapGestureRecognizer *goToInfoForm3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToITAForm:)];
    [goToInfoForm3 setDelegate:self];
    [butStart addGestureRecognizer:goToInfoForm3];
    goToInfoForm3.numberOfTapsRequired = 1;
    
    if (event.type.intValue==0)
    {
        butStart.enabled = NO;
        
    }
    else butStart.enabled = YES;
    
    UITapGestureRecognizer *goToInfoForm4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTypeOfInterview:)];
    [goToInfoForm4 setDelegate:self];
    [labelType addGestureRecognizer:goToInfoForm4];
    goToInfoForm4.numberOfTapsRequired = 1;

    UITapGestureRecognizer *startInterview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToITAForm:)];
    [startInterview setDelegate:self];
    [butStart addGestureRecognizer:startInterview];
    startInterview.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *changeType = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTypeOfInterview:)];
    [changeType setDelegate:self];
    [labelType addGestureRecognizer:changeType];
    changeType.numberOfTapsRequired = 1;

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
            [NSPredicate predicateWithFormat:@"interviewUrl == %@",_curInterview.url];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Interview"
                                                      inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            for (InterviewAppointment *info in fetchedObjects) {
                info.type = [NSNumber numberWithInt:buttonIndex];
            }
            
        }
    
}


- (void)chooseTypeOfInterview:(id)sender
{
      UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
    NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
    
    NSArray *eventsOnThisDay = [[self.sortedWeeks objectAtIndex:tappedRow.section] interviews];
    InterviewAppointment *event = [eventsOnThisDay objectAtIndex:tappedRow.row];
    
    _actionSheetTypes = [[UIActionSheet alloc] initWithTitle:@"Select type of interview:"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"None", @"IT Academy", @"Internal", @"External",nil];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            UICollectionViewCell *curInterviewCell = [self.collectionView  cellForItemAtIndexPath:tappedRow];
            _label = [curInterviewCell viewWithTag:100];
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
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView: _collectionView];
    
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint: currentTouchPosition];
    
    // unused variable!!!!!
    
    __unused NSArray *eventsOnThisDay = [[self.sortedWeeks objectAtIndex:indexPath.section] interviews];
    __unused InterviewAppointment *interview = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    // end of unused variable!!!!
    
    
    [self sendEmailToAddress:@"elena.pyanyh@gmail.com"];
}


@end
