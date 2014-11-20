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
@interface EHListOfInterviewsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

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



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"GoToInterviewForm"])
    {
        
      //  UIView *senderButton = (UIView*) sender;
      //  NSIndexPath *indexPath = [_collectionView indexPathForCell: (UICollectionViewCell*)[[senderButton superview]superview]]; // get the address of cell where pushed button is, so that you can send the exact info that you need to send to the next view
        
        
//        EHInterviewFromViewController * interviewForm = [segue destinationViewController];
//        NSIndexPath * myIndexPath = [self.tableView indexPathForSelectedRow];
//        int row = [myIndexPath row];
//        NSString *dateRepresentingThisDay = [self.sortedWeeks objectAtIndex:myIndexPath.section];
//        NSArray *eventsOnThisDay = [self.sortedWeeks objectForKey:dateRepresentingThisDay];
//        EKEvent *event = [eventsOnThisDay objectAtIndex:row];
//        interviewForm.date = [self.cellDateFormatter stringFromDate:event.startDate];
        
    }
    
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
    
    
    labelType.text = [@" " stringByAppendingString:event.typeOfInterview];
    labelDate.text = [@" "stringByAppendingString:[cellDateFormatter stringFromDate:event.dateOfInterview]];
    if (event.locationOfInterview==nil)
    {
         labelLocation.text = @" Unknown" ;
    }
    else labelLocation.text = [@" " stringByAppendingString:event.locationOfInterview];
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
    
  
    UITapGestureRecognizer * single = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singletap:)];
    
    [labelCandidate addGestureRecognizer:single];
    single.numberOfTapsRequired = 1;

    return cell;
    
    
}

-(void) singletap:(id)sender
{
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    
    if (tapGR.view.tag == 103)
    {
        CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.collectionView];
        
        NSIndexPath *tappedRow = [self.collectionView indexPathForItemAtPoint:touchLocation];

        EHInterview * curInterview = [[EHInterview alloc]init];
        curInterview= [[[sortedWeeks objectAtIndex:tappedRow.section ] interviews] objectAtIndex:tappedRow.row];
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"You press label !"
//                                                          message:[NSString stringWithFormat:@"interview with %@", temp]
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        [message show];
        
     
        
        //
    EHCandidateFormViewController * candidateForm = [[EHCandidateFormViewController alloc]init];
        candidateForm.nameOfCandidate = curInterview.nameOfCandidate;
        candidateForm.lastnameOfCandidate = curInterview.lastNameOfCandidate;
    

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
