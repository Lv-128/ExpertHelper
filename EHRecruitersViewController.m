//
//  EHRecruitersViewController.m
//  ExpertHelper
//
//  Created by alena on 12/5/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHRecruitersViewController.h"
#import "EHListOfRecruitersCell.h"
@interface EHRecruitersViewController ()


@end

@implementation EHRecruitersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _recruitersArray = [[NSArray alloc] init];
    EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    [self getAllRecruitersFromDB];

}




#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recruitersArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"recruiterCell";
    EHListOfRecruitersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[EHListOfRecruitersCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    cell.nameLabel.text = [NSString stringWithFormat: @" %@ %@ ", [_recruitersArray[indexPath.row] firstName], [_recruitersArray[indexPath.row] lastName]];
    cell.skypeLabel.text = [_recruitersArray[indexPath.row] skypeAccount];
    cell.recruiterEmail.text = [_recruitersArray[indexPath.row] email];
    if ([_recruitersArray[indexPath.row] photoUrl] == nil)
    {
      
        [cell.picture setImage:[UIImage imageNamed:@"contact.png"]];
        
        
    }
    
   // cell.detailTextLabel.text = [NSString stringWithFormat: @" %d interviews", numOfInterviews];
    
    return cell;
}

- (void)getAllRecruitersFromDB
{
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Recruiter entityName]
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    _recruitersArray= [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
}

@end
