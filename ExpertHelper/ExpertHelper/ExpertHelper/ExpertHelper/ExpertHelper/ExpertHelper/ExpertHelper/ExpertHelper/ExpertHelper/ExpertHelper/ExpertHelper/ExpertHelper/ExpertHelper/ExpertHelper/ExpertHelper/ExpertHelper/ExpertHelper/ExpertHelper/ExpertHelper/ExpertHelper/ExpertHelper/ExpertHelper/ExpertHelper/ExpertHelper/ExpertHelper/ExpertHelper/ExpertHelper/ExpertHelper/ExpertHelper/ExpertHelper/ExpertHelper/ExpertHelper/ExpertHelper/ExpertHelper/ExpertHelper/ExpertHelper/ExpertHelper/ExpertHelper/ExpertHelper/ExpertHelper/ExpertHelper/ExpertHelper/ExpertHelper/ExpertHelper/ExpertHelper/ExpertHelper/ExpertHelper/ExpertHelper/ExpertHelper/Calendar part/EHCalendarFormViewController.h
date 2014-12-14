//
//  TableViewController2.h
//  firstCalendarFrom
//
//  Created by alena on 10/28/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHRevealViewController.h"

@interface EHCalendarFormViewController : UITableViewController
{
    IBOutlet UILabel *label;
   
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

-(IBAction)segmentButton:(id)sender;
@end