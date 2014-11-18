//
//  EHMainEventsTableViewController.h
//  ExpertHelper
//
//  Created by alena on 11/14/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHMainEventsTableViewController : UITableViewController

@property (copy, nonatomic) NSDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;

@end
