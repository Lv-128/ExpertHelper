
//  CLExternalViewController.m
//  firstCalendarFrom
//
//  Created by alena on 10/30/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import "EHExternalViewController.h"
#import "EHRecorderCommentController.h"
#import "EHExternalCell.h"
#import "EHSkillLevelPopup.h"
#import "EHSkillsProfilesParser.h"

@interface EHExternalViewController () <UITableViewDataSource, UITableViewDelegate, EHSkillLevelPopupDelegate, EHRecorderCommentControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *openGeneralInfo;
- (IBAction)openGeneralInfo:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSections;
@property (nonatomic, strong) NSArray *sectionContent;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *comment;
@property (nonatomic, strong) EHSkillsProfilesParser *pars;
@property (nonatomic, strong) EHGenInfo *generInfo;

@end

@implementation EHExternalViewController

- (void)EHRecorderCommentController:(EHRecorderCommentController *)externalWithComment
                  transmittingArray:(NSArray *)level withIndex:(NSIndexPath *)index andCommentArray:(NSArray *)comment
{
    _array = [level mutableCopy];
    _comment = [comment mutableCopy];
    
    NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:index.section inSection:index.row];
    NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

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
    
    if (temp == nil)
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
    _comment = [[NSMutableArray alloc]initWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGeninfo:) name:@"GetInfo" object:nil];
    
    _pars = [[EHSkillsProfilesParser alloc]init];
    
    
    
    if (_interview.idExternal.idGeneralInfo != nil && _interview.idExternal.skills.count != 0)
    {
        _pars.interview = _interview;
        _pars.externalInterview = _interview.idExternal;
       // _pars.genInfo = _interview.idExternal.idGeneralInfo;
        
        [_pars getFromDB];
        
        NSMutableArray *myArr = [[NSMutableArray alloc]initWithCapacity:_array.count];
        for (int i = 0; i < self.tableSections.count; i++)
       {
           for(int j = 0; j<_pars.groups.count; j++)
           {
               if ([self.tableSections[i]  isEqualToString: [_pars.groups[j] nameOfSections]])
                   {
                      
                       NSArray *arr = [[_pars.groups[j] skills] allObjects];
                   
                       myArr[i] = arr;
                   }
           
           }
           
       }
        
        
        
        
           NSMutableArray * tt = [[NSMutableArray alloc]initWithCapacity:0];
           for (int i = 0; i < myArr.count; i++)
           {
               tt = [[NSMutableArray alloc]initWithCapacity:0];
               for(int j = 0; j<[myArr[i]count];j++)
               {
                   
                   [tt addObject:[myArr[i][j] estimate]];

                   }
                    [_array insertObject:tt atIndex:i];
               }
        
        
        
        
        
        for (int i = 0; i < self.tableSections.count; i++)//6
        {
            NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:0];// group
            NSLog(@"%d",[temp count]);
            
            
            NSLog(@"%d",[[self.sectionContent objectAtIndex:i] count]);
            for (int b = 0; b < [[self.sectionContent objectAtIndex:i] count]; b++)
                
                [temp addObject:@""];
            
               [_comment insertObject:temp atIndex:i];
        }
        
    }
    else{
        
        
    for (int i = 0; i < self.tableSections.count; i++)//6
    {
        NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:0];// group
        NSLog(@"%d",[temp count]);
        
        
        NSLog(@"%d",[[self.sectionContent objectAtIndex:i] count]);
        for (int b = 0; b < [[self.sectionContent objectAtIndex:i] count]; b++)
            
            [temp addObject:@""];
        
        [_array insertObject:temp atIndex:i];
        [_comment insertObject:temp atIndex:i];
    }
    }
    self.openGeneralInfo.layer.cornerRadius = 13;
    self.openGeneralInfo.layer.borderWidth = 1;
    self.openGeneralInfo.layer.borderColor = [UIColor grayColor].CGColor;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"profa"])
    {
        EHRecorderCommentController *external = [segue destinationViewController];
        external.delegate = self;
        external.level = _array;
        external.index = _index;
        external.comment = _comment;
    }
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
    return [self.sectionContent[section]count];
}

#pragma mark tableview methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create custom view to display section header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 18.0)];
    //create custom class!
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 728, 18.0)];
    [labelLeft setFont:[UIFont boldSystemFontOfSize:15]];
    [labelLeft setTextAlignment:NSTextAlignmentCenter];
    
    labelLeft.text = [self.tableSections objectAtIndex:section];

    [view addSubview:labelLeft];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    
    return view;
}

- (EHExternalCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    
    EHExternalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExternalCell"];
    cell.textLabel.text = [listData objectAtIndex:row];
    
    NSObject *tt = [[_array objectAtIndex:indexPath.section] objectAtIndex:row];
    if (tt != nil) {
        cell.rightLabel.text = [[_array objectAtIndex:indexPath.section] objectAtIndex:row];
    } else {
        cell.rightLabel.text = @"";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"profa" sender:cell];
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
    
    if (isPopup == NO) {
        CGRect selfFrame = self.view.frame;
        CGRect popupFrame = popup.frame;
        popupFrame.size.width = selfFrame.size.width;
        popupFrame.origin.y = selfFrame.size.height;
        popupFrame.origin.y -= popupFrame.size.height;
        popup.frame = popupFrame;
        
        popup.delegate = self;
        popup.transform = CGAffineTransformMakeScale(1.3, 1.3);

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

}

- (void)parsFunc
{
    NSMutableArray *profTransmitting = [[NSMutableArray alloc]init];
    
    for (int y = 0; y < _tableSections.count; y++) {
        EHGroups *groupsOfExternal = [[EHGroups alloc]init];
        NSMutableArray *groupsTransmitting = [[NSMutableArray alloc]init];
        
        for (int x = 0; x < [[self.sectionContent objectAtIndex:y] count]; x++) {
            EHSkill *skillsOfExternal = [[EHSkill alloc]init];
            skillsOfExternal.nameOfSkill = _sectionContent[y][x];
            (![_array[y][x] isEqual:@""]) ? (skillsOfExternal.estimate = _array[y][x]): (skillsOfExternal.estimate = @"None");
            
           
            (![_comment[y][x] isEqual:@""]) ? (skillsOfExternal.comment = _comment[y][x]): (skillsOfExternal.comment = @"None");
            
            [groupsTransmitting addObject:skillsOfExternal];
        }
        groupsOfExternal.skills = groupsTransmitting;
        groupsOfExternal.nameOfSections = _tableSections[y];
        [profTransmitting addObject:groupsOfExternal];
    }
    
   _pars = [[EHSkillsProfilesParser alloc]initWithDataGroups:profTransmitting andInterview:_interview andGenInfo:_generInfo];
}

- (void)getGeninfo:(NSNotification *)notification
{
        self.generInfo = notification.userInfo[@"genInfo"];
}

- (IBAction)saveForm:(id)sender {
    [self parsFunc];
}

@end

















