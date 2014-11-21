//
//  EHListOfInterviewsViewController.m
//  ExpertHelper
//
//  Created by alena on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHListOfInterviewsViewController.h"
#import <EventKit/EventKit.h>
#import "EHInterview.h"
#import "EHEventsGetInfoParser.h"
#import "EHCandidateFormViewController.h"
#import "EHRecruiterViewController.h"
#import "EHITAViewController.h"
@interface EHListOfInterviewsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *otherTextLabels;


@end

@implementation EHListOfInterviewsViewController

@synthesize cellDateFormatter;
@synthesize sortedWeeks;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [self.sortedWeeks count];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    EHWeek *weekOfMonth = [self.sortedWeeks objectAtIndex:section];
    
    return [weekOfMonth.interviews count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    NSArray *eventsOnThisDay = [[self.sortedWeeks objectAtIndex:indexPath.section] interviews];
    EHInterview *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    
    UILabel * labelType = (UILabel *) [cell viewWithTag:100];
    UILabel * labelDate = (UILabel *) [cell viewWithTag:101];
    UILabel * labelLocation = (UILabel *) [cell viewWithTag:102];
    UILabel * labelCandidate = (UILabel *) [cell viewWithTag:103];
    UILabel * labelRecruiter = (UILabel *) [cell viewWithTag:104];
    UIButton * butStart = (UIButton * ) [cell viewWithTag:1000];
    
    labelType.text = [@" " stringByAppendingString:event.typeOfInterview];
    labelDate.text = [@" "stringByAppendingString:[cellDateFormatter stringFromDate:event.dateOfInterview]];
    
    if (event.locationOfInterview==nil)
    {
        labelLocation.text = @" Unknown" ;
    }
    else
        labelLocation.text = [@" " stringByAppendingString:event.locationOfInterview];
    
    labelCandidate.text = [@" " stringByAppendingString:[[event.nameOfCandidate stringByAppendingString:@" "] stringByAppendingString:event.lastNameOfCandidate]  ] ;
    labelRecruiter.text = [@" " stringByAppendingString:[[event.nameOfRecruiter stringByAppendingString:@" "] stringByAppendingString:event.lastNameOfRecruiter]  ] ;
    
    NSArray * arrLabels = [NSArray arrayWithObjects:labelType,labelDate,labelLocation,labelCandidate,labelRecruiter,nil];
    for (UILabel* label in arrLabels)
    {
        //[label.layer  setCornerRadius:15.0f];
        // [label.layer setBorderWidth:2.0f];
        [label.layer setBorderColor:[UIColor grayColor].CGColor];
    }
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [cell.layer setCornerRadius:30.0f];
    
    
    
    UITapGestureRecognizer * goToInfoForm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo:)];
    [goToInfoForm setDelegate:self];
    // [labelRecruiter addGestureRecognizer:goToInfoForm];
    [labelCandidate addGestureRecognizer:goToInfoForm];
    goToInfoForm.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer * goToInfoForm2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo:)];
    [goToInfoForm2 setDelegate:self];
    [labelRecruiter addGestureRecognizer:goToInfoForm2];
    goToInfoForm2.numberOfTapsRequired = 1;
    
    
    UITapGestureRecognizer * goToInfoForm3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToITAForm:)];
    [goToInfoForm3 setDelegate:self];
    [butStart addGestureRecognizer:goToInfoForm3];
    goToInfoForm3.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer * goToInfoForm4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTypeOfInterview:)];
    [goToInfoForm4 setDelegate:self];
    [labelType addGestureRecognizer:goToInfoForm4];
    goToInfoForm4.numberOfTapsRequired = 1;
    
    return cell;
}



-(void)chooseTypeOfInterview:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
    NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
    if (tapGR.view.tag == 100)
    {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select type of interview:"
                                                                 delegate:self /// here will be delegate
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"None", @"IT Academy", @"Internal", @"External",nil];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
        
            
            UICollectionViewCell * curInterview = [self.collectionView  cellForItemAtIndexPath:tappedRow];
            UIView * label = [curInterview viewWithTag:100];
            //[actionSheet showFromRect:[curLabel frame] inView:self.view animated:YES];
            
            CGRect  rect = CGRectMake([label frame].origin.x- [label frame].size.width/3 , [label frame].origin.y, [label frame].size.width,  [label frame].size.height) ;
            
            // [label frame]
            [actionSheet showFromRect:rect inView:curInterview animated:YES ];//showFromRect:[label  frame] inView:self.view animated:YES];
        }
        else
        {
            
            //  [actionSheet showInView:self.view];
        }
        
        actionSheet.tag = 300;
        
    }
}




-(void)goToInfo:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    
    if (tapGR.view.tag == 103)
    {
        CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
        
        NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
        
        EHInterview * curInterview = [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] objectAtIndex:tappedRow.row];
        EHCandidateFormViewController *candidateForm = [self.storyboard instantiateViewControllerWithIdentifier:@"CandidateFormView"];
        candidateForm.nameOfCandidate = curInterview.nameOfCandidate;
        candidateForm.lastnameOfCandidate = curInterview.lastNameOfCandidate;
        candidateForm.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:candidateForm animated:YES ];
    }
    if (tapGR.view.tag == 104)
    {
        CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
        
        NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];
        
        EHInterview * curInterview =  [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] objectAtIndex:tappedRow.row];
        
        EHRecruiterViewController *recruiterViewForm = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruiterFormView"];
        recruiterViewForm.nameOfRecruiter = curInterview.nameOfRecruiter;
        recruiterViewForm.lastnameOfRecruiter = curInterview.lastNameOfRecruiter;
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
        EHInterview * curInterview =[[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] objectAtIndex:tappedRow.row];
        if([curInterview.typeOfInterview  isEqual: @"ITA"])
        {
            EHITAViewController *recruiterViewForm = [self.storyboard instantiateViewControllerWithIdentifier:@"ITAForm"];
            [self.navigationController pushViewController:recruiterViewForm animated:YES];
            
        }
        else{
            EHITAViewController *recruiterViewForm = [self.storyboard instantiateViewControllerWithIdentifier:@"InternalForm"];
            [self.navigationController pushViewController:recruiterViewForm animated:YES];
        }
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        }
        
        UILabel * label = (UILabel *) [reusableview viewWithTag:1000];
        
        NSString *dateRepresentingThisDay = [[self.sortedWeeks objectAtIndex:indexPath.section]nameOfWeek];
        label.text=dateRepresentingThisDay;
        return reusableview;
    }
    return nil;
}


@end
