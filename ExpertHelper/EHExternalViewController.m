//
//  CLExternalViewController.m
//  firstCalendarFrom
//
//  Created by alena on 10/30/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import "EHExternalViewController.h"
#import "EHExternalCell.h"
#import "EHSkillLevelPopup.h"

@interface EHExternalViewController () <UITableViewDataSource, UITableViewDelegate, EHSkillLevelPopupDelegate>

@property (weak, nonatomic) IBOutlet UIButton *openGeneralInfo;
- (IBAction)openGeneralInfo:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSections;
@property (nonatomic, strong) NSArray *sectionContent;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation EHExternalViewController

- (void)skillLevelPopup:(EHSkillLevelPopup *)popup
         didSelectLevel:(EHSkillLevel)level {
    
    [UIView animateWithDuration:0.85 animations:^{
        popup.transform = CGAffineTransformMakeScale(0, 0);
        popup.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [super viewDidLoad];
    }];
    isPopup = NO;
    newCell = YES;
    
    NSIndexPath *rowToReload = [NSIndexPath indexPathForRow: RowAtIndexPathOfSkills inSection:lostData];
    NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    
    NSMutableArray *temp = [_array objectAtIndex:rowToReload.section];
    
    if (!temp)
    {
        temp = [[NSMutableArray alloc]init];
        [temp insertObject:popup.skillLevel atIndex:rowToReload.row];
        [_array insertObject:temp atIndex:rowToReload.section];
    }else
        [[_array objectAtIndex:rowToReload.section] insertObject:popup.skillLevel atIndex:rowToReload.row];
    
    [self.tableView reloadRowsAtIndexPaths: rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad
{
  // _tableFrame = self.tableView.frame;
    isPopup = NO;
    newCell = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableSections = @[@"Design", @"Construction", @"Quality", @"Configuration Management", @"Scope Management and Software Engineering", @"Profiles"];
    self.sectionContent = @[@[ @"Object oriented programming and design", @"Designing solution architecture", @"Database design" ],
                            @[ @"Coding (primary language and standard libraries)", @"Debugging and bug fixing" ],
                            @[ @"Using issue tracking systems", @"Reviewing code" ],
                            @[ @"Versions management", @"Build management" ],
                            @[ @"Gathering and managing requirements", @"Preparing estimations", @"Writing proposals" ],
                            @[ @"Core", @"Desktop", @"Web", @"DB", @"BI", @"RIA", @"Multimedia", @"Mobile", @"Embedded", @"Integration" ]];
    
    _array = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0; i < self.tableSections.count; i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:0];
        for (int b = 0; b < [[self.sectionContent objectAtIndex:i] count]; b++)
            [temp addObject:@""];
        
        [_array insertObject:temp atIndex:i];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableSections count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionContent[section] count];
}

#pragma mark tableview methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create custom view to display section header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 18.0)];
    //create custom class!
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 504, 18.0)];
    [labelLeft setFont:[UIFont boldSystemFontOfSize:14]];
    [labelLeft setTextAlignment:NSTextAlignmentCenter];
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(504, 0.0, 224, 18.0)];
    [labelRight setFont:[UIFont boldSystemFontOfSize:14]];
    [labelRight setTextAlignment:NSTextAlignmentCenter];
    
    labelLeft.text = [self.tableSections objectAtIndex:section];
    labelRight.text = @"Estimate";
    
    [view addSubview:labelLeft];
    [view addSubview:labelRight];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ExternalCell";
    
    NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    
    EHExternalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[EHExternalCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    
    //Create custom cell!
    
    cell.leftLabel.text = [listData objectAtIndex:row];
    [cell.leftLabel.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.leftLabel.layer setBorderWidth:1.0];
    
//    UITapGestureRecognizer *goToInfoForm2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo:)];
//    [goToInfoForm2 setDelegate:self];
//    [labelRecruiter addGestureRecognizer:goToInfoForm2];
//    goToInfoForm2.numberOfTapsRequired = 1;
    
    NSObject *tt = [[_array objectAtIndex:indexPath.section]objectAtIndex:row];
    
    if(tt)
        cell.rightLabel.text = [[_array objectAtIndex:indexPath.section]objectAtIndex:row];

    cell.rightLabel.textAlignment = NSTextAlignmentCenter;
    [cell.rightLabel.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [cell.rightLabel.layer setBorderWidth:1.0];
    
//    NSInteger sectionsAmount = [tableView numberOfSections];
//    NSInteger rowsAmount = [tableView numberOfRowsInSection:[indexPath section]];
//    if ([indexPath section] == sectionsAmount && [indexPath row] == rowsAmount) {
//        [cell.layer setBorderColor:[[UIColor colorWithWhite:0.5 alpha:1.000] CGColor]];
//        [cell.layer setBorderWidth:2.0];
//    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    NSUInteger row = [indexPath row];
    NSString *rowValue = [listData objectAtIndex:row];
    
    lostData = [indexPath section];
    RowAtIndexPathOfSkills = row;
    
    NSString *message = [[NSString alloc] initWithString:rowValue];
    UINib *nib = [UINib nibWithNibName:@"EHSkillLevelPopup" bundle:nil];
    EHSkillLevelPopup *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
    
    if (!isPopup) {
        CGRect r = self.view.frame;
        CGRect f = popup.frame;
        f.size.width = r.size.width;
        f.origin.y = r.size.height;
        f.origin.y -= f.size.height;
        popup.frame = f;
        popup.delegate = self;
        popup.layer.cornerRadius = 6;
        popup.layer.shadowOpacity = 0.8;
        popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
        popup.alpha = 0;
        popup.titleLabel.text = [NSString stringWithFormat:@"Select the desired level for direction: %@", message];
        [self.view addSubview:popup];
        
        [UIView animateWithDuration:0.5 animations:^{
            popup.alpha = 1;
            popup.transform = CGAffineTransformMakeScale(1, 1);
        }];
        isPopup = YES;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)openGeneralInfo:(UIButton *)sender {
    
//        BOOL bla;
//    bla = YES;
    
    
//    f.size.width = r.size.width;

//    childFrame.origin.y += childFrame.size.height;
    
//    if (bla) {

//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect selfFrame = self.view.frame;
//            CGRect buttonFrame = self.openGeneralInfo.frame;
//            CGRect childFrame = [self.childViewControllers[0] view].frame;
//            
//            //childFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height;
//            childFrame.size.height = selfFrame.size.height / 3;
//            [self.childViewControllers[0] view].frame = childFrame;
//            [self.childViewControllers[0] view].alpha = 1;
//            
//            CGRect tableFrame = self.tableView.frame;
//            
//            tableFrame.origin.y += 200;
//            self.tableView.frame = tableFrame;
//
//            
//        }completion:^(BOOL finished) {
//
//        } ];
//    
//        bla = NO;
//    }
    


    
    
    UINib *nib = [UINib nibWithNibName:@"EHGeneralInfo" bundle:nil];
    EHSkillLevelPopup *generalInfo = [[nib instantiateWithOwner:nil options:nil] lastObject];

    
//    CGRect g = self.view.frame;
//    CGRect buttonFrame = self.openGeneralInfo.frame;
//    CGRect f = generalInfo.frame;
//    
//    f.size.width = g.size.width;
//    f.origin.y = buttonFrame.origin.y + buttonFrame.size.height;
//    generalInfo.frame = f;
//
//    
//    CGRect t = self.tableView.frame;
//    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
//    t.origin.y += f.size.height;
//    self.tableView.frame = t;
//    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect selfFrame = self.view.frame;
        CGRect buttonFrame = self.openGeneralInfo.frame;
        CGRect childFrame = generalInfo.frame;
        
        childFrame.size.width = selfFrame.size.width - 40;
        childFrame.origin.x = selfFrame.origin.x + 20;
        childFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height + 5;
        childFrame.size.height = generalInfo.frame.size.height;
        generalInfo.frame = childFrame;
        generalInfo.alpha = 1;
        
        CGRect tableFrame = self.tableView.frame;
        
        tableFrame.origin.y += 300;
        self.tableView.frame = tableFrame;

        

    }completion:^(BOOL finished) {
       
        [self.view addSubview:generalInfo];
      
           }];


}

@end

















