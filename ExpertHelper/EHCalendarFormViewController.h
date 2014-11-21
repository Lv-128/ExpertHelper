//
//  TableViewController2.h
//  firstCalendarFrom
//
//  Created by alena on 10/28/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EHCalendarFormViewController : UITableViewController
{
    IBOutlet UILabel *label;
    IBOutlet UISegmentedControl *segment;
    int whichTypeOfInterviewIsChosen;
}
-(IBAction)segmentButton:(id)sender;
@end