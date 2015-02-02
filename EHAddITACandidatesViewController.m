//
//  EHAddITACandidatesViewController.m
//  ExpertHelper
//
//  Created by adminaccount on 1/28/15.
//  Copyright (c) 2015 Katolyk S. All rights reserved.
//

#import "EHAddITACandidatesViewController.h"

@interface EHAddITACandidatesViewController ()

@end

@implementation EHAddITACandidatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addCandidate:(id)sender
{
    [_lastName resignFirstResponder];
    [_firstName resignFirstResponder];
    
    EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error = nil;

    ITAInterview *itaInterview  = _interview.idITAInterview;
    
    Candidate *candidateResult;
  
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Candidate entityName]
                                              inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName == %@ AND lastName == %@ ",_firstName.text,_lastName.text];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    if (fetchedObjects.count > 0)// we don't need this actually
        for (Candidate *candidate in fetchedObjects)
            candidateResult = candidate;
    else
    {
        candidateResult = [NSEntityDescription insertNewObjectForEntityForName:[Candidate entityName]
                                                        inManagedObjectContext:context];
        candidateResult.firstName = _firstName.text;
        candidateResult.lastName = _lastName.text;
    }

    [itaInterview.candidatesSet addObject:candidateResult];
    
    _lastName.text = @"";
    _firstName.text = @"";
    
    if (![context save:&error])
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
}

@end

