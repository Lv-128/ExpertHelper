//
//  EHRecruitersViewController.h
//  ExpertHelper
//
//  Created by alena on 12/5/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHAppDelegate.h"

@interface EHRecruitersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *recruitersArray;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
