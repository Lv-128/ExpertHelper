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
@interface EHListOfInterviewsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@end

@implementation EHListOfInterviewsViewController

@synthesize cellDateFormatter;
@synthesize sections;
@synthesize sortedDays;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.sortedDays = [self.sections allKeys];
     _interviews = [NSArray arrayWithObjects:@"interview 1", @"interview 2", @"interview 3" , @"interview 4", nil];
  //   [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
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
        
        UIView *senderButton = (UIView*) sender;
        NSIndexPath *indexPath = [_collectionView indexPathForCell: (UICollectionViewCell*)[[senderButton superview]superview]]; // get the address of cell where pushed button is, so that you can send the exact info that you need to send to the next view
        
        
//        EHInterviewFromViewController * interviewForm = [segue destinationViewController];
//        NSIndexPath * myIndexPath = [self.tableView indexPathForSelectedRow];
//        int row = [myIndexPath row];
//        NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:myIndexPath.section];
//        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
//        EKEvent *event = [eventsOnThisDay objectAtIndex:row];
//        interviewForm.date = [self.cellDateFormatter stringFromDate:event.startDate];
        
    }
    
}
#pragma mark Collection View Methods



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [self.sections count];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
     EHInterview *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    
    
    UILabel * labelType = (UILabel *) [cell viewWithTag:100];
    UILabel * labelDate = (UILabel *) [cell viewWithTag:101];
    UILabel * labelLocation = (UILabel *) [cell viewWithTag:102];
    UILabel * labelCandidate = (UILabel *) [cell viewWithTag:103];
    UILabel * labelRecruiter = (UILabel *) [cell viewWithTag:104];
    
    
    labelType.text = [@"Type : " stringByAppendingString:event.typeOfInterview];
    labelDate.text = [@"Date : "stringByAppendingString:[cellDateFormatter stringFromDate:event.dateOfInterview]];
    if (event.locationOfInterview==nil)
    {
         labelLocation.text = @"Location : Unknown" ;
    }
    else labelLocation.text = [@"Location : " stringByAppendingString:event.locationOfInterview];
    labelCandidate.text = [@"Candidate : " stringByAppendingString:[[event.nameOfCandidate stringByAppendingString:@" "] stringByAppendingString:event.lastNameOfCandidate]  ] ;
     labelRecruiter.text = [@"Recruiter : " stringByAppendingString:[[event.nameOfRecruiter stringByAppendingString:@" "] stringByAppendingString:event.lastNameOfRecruiter]  ] ;
  /*  NSArray * arrLabels = [NSArray arrayWithObjects:labelType,labelDate,labelLocation,labelCandidate,labelRecruiter,nil];
    for (UILabel* label in arrLabels)
    {
        [label.layer  setCornerRadius:15.0f];
    }
    */
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor blackColor].CGColor];
    
    [cell.layer setCornerRadius:30.0f];
    
  

  

    return cell;
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
       
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        }
        
        int tt =indexPath.section;
      //  NSLog([NSString stringWithFormat: @"%d",tt]);
        UILabel * label = (UILabel *) [reusableview viewWithTag:1000];
        
        NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:tt];
        
        
        label.text=dateRepresentingThisDay;
       // [reusableview addSubview:label];
        
        
        [reusableview.layer setBorderWidth:2.0f];
        [reusableview.layer setCornerRadius:15.0f];
        [reusableview.layer  setBorderColor:[UIColor whiteColor].CGColor];
        
        
        return reusableview;
    }
    return nil;
}


@end
