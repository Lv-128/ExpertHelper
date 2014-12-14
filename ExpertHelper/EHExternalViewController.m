
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
#import "ZipArchive.h"

@interface EHExternalViewController () <UITableViewDataSource, UITableViewDelegate, EHSkillLevelPopupDelegate, EHRecorderCommentControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *openGeneralInfo;
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
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterLongStyle];  
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
            for (int b =0; b<[self.sectionContent[i]count];b++)
            {
                for(int j = 0; j<[myArr[i]count];j++)
                {
                    
                    
                    if ([[myArr[i][j] nameOfSkill] isEqualToString:self.sectionContent[i][b]])
                    {
                        [tt addObject:[myArr[i][j] estimate]];
                    }
                }
            }
            [_array insertObject:tt atIndex:i];
        }
        
        
        
        
        
        for (int i = 0; i < self.tableSections.count; i++)//6
        {
            NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:0];// group
            for (int b = 0; b < [[self.sectionContent objectAtIndex:i] count]; b++)
                
                [temp addObject:@""];
            
            [_comment insertObject:temp atIndex:i];
        }
        
    }
    else{
        
        
        for (int i = 0; i < self.tableSections.count; i++)//6
        {
            NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:0];// group
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

- (void)parsFunc
{
    NSMutableArray *profTransmitting = [[NSMutableArray alloc]init];
    
    for (int y = 0; y < _tableSections.count; y++) {
        EHGroups *groupsOfExternal = [[EHGroups alloc]init];
        NSMutableArray *groupsTransmitting = [[NSMutableArray alloc]init];
        
        for (int x = 0; x < [[self.sectionContent objectAtIndex:y] count]; x++) {
            EHSkill *skillsOfExternal = [[EHSkill alloc]init];
            skillsOfExternal.nameOfSkill = _sectionContent[y][x];
            if (![_array[y][x]  isEqual: @""]) {
                skillsOfExternal.estimate = _array[y][x];
            }
            else {
                skillsOfExternal.estimate = @"None";
                _array[y][x] = @"None";
            }
            
            if (![_comment[y][x]  isEqual: @""]) {
                skillsOfExternal.estimate = _comment[y][x];
            }
            else {
                skillsOfExternal.estimate = @"None";
                _comment[y][x] = @"None";
            }
            
            [groupsTransmitting addObject:skillsOfExternal];
        }
        groupsOfExternal.skills = groupsTransmitting;
        groupsOfExternal.nameOfSections = _tableSections[y];
        [profTransmitting addObject:groupsOfExternal];
    }
    
    
    if (_generInfo == nil)
    {
        UIAlertView *message  = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                           message:@"Fill general info!!"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [message show];
    }
    else
    {
        _pars = [[EHSkillsProfilesParser alloc]initWithDataGroups:profTransmitting andInterview:_interview andGenInfo:_generInfo];
        [_pars saveInfoToDB];
    }
    
}


- (void)getGeninfo:(NSNotification *)notification
{
    self.generInfo = notification.userInfo[@"genInfo"];
}

- (IBAction)saveForm:(id)sender {
    //NSLog(@"%@", NSHomeDirectory());
    [self parsFunc];
    [self unzip];
    
    
    //----------------------------------- start parsing part inside action -------------------------------
    
    NSError *error;
    
    NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"unZipDirName1"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"xl"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"worksheets"];
    NSString *filePath2 = [filePath1 stringByAppendingPathComponent:@"sheet4.xml"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"sheet3.xml"];
    NSMutableString* xml = [[NSMutableString alloc] initWithString:[NSMutableString stringWithContentsOfFile:filePath1 encoding:NSUTF8StringEncoding error:&error]];
    
    NSArray *a = [[NSArray alloc] initWithObjects:@"E21", @"E22", @"E23", @"E25", @"E26", @"E28", @"E29", @"E31", @"E32", @"E34", @"E35", @"E36", nil];
    int indexForA = 0;
    NSString *ss = [[NSString alloc] init];
    NSString *stringForComparing = @"<c r=\"";
    
    NSDictionary *map= [[NSDictionary alloc] initWithObjectsAndKeys:@"291", @"None", @"292", @"Low", @"293", @"Middle", @"294", @"Strong", nil];
    int nextPart = 0;
    
    for (int y = 0; y < _tableSections.count; y++) {
        if (indexForA >= 12) break;
        for (int x = 0; x < [[self.sectionContent objectAtIndex:y] count]; x++) {
            stringForComparing = @"<c r=\"";
            stringForComparing = [stringForComparing stringByAppendingString:a[indexForA]];
            stringForComparing = [stringForComparing stringByAppendingString:@"\""];
            
            for (int i = nextPart; i < xml.length - 10; i++) {
                ss = [xml substringWithRange:NSMakeRange(i, 10)];
                if ([ss isEqual:stringForComparing]) {
                    int k = 0;
                    for (int j = i + 10; j < xml.length - 10; j++) {
                        if ([xml characterAtIndex:j] == '/') {
                            k = j + 1;
                            break;
                        }
                    }
                    NSMutableString *str = [[NSMutableString alloc] init];
                    str = [@"<c r=\"" mutableCopy];
                    [str appendString:a[indexForA]];
                    [str appendString:@"\" s=\"105\" t=\"s\"><v>"];
                    [str appendString:[map valueForKey:_array[y][x]]];
                    [str appendString:@"</v></c>"];
                    
                    xml = [[xml stringByReplacingCharactersInRange: NSMakeRange(i, k - i + 1) withString:str] mutableCopy];
                    
                    str = [@"" mutableCopy];
                    indexForA++;
                    nextPart = i;
                    break;
                }
            }
        }
    }
    [xml writeToFile:filePath1 atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    // ------------------------------------------- parsing for profiles -----------------------------
    
    NSMutableString* xml1 = [[NSMutableString alloc] initWithString:[NSMutableString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:&error]];
    
    NSArray *b = [[NSArray alloc] initWithObjects:@"B8", @"C8", @"D8", @"E8", @"F8", @"G8", @"H8", @"I8", @"J8", @"K8", nil];
    int indexForB = 0;
    nextPart = 0;
    for (int x = 0; x < [[self.sectionContent objectAtIndex:_tableSections.count-1] count]; x++) {
        stringForComparing = @"<c r=\"";
        stringForComparing = [stringForComparing stringByAppendingString:b[indexForB]];
        stringForComparing = [stringForComparing stringByAppendingString:@"\""];
        ss=@"";
        for (int i = nextPart; i < xml1.length - 9; i++) {
            if (indexForB >= 10) break;
            ss = [xml1 substringWithRange:NSMakeRange(i, 9)];
            if ([ss isEqual:stringForComparing]) {
                int k = 0;
                for (int j = i + 10; j < xml1.length - 9; j++) {
                    if ([xml1 characterAtIndex:j] == '/') {
                        k = j + 1;
                        break;
                    }
                }
                NSMutableString *str = [[NSMutableString alloc] init];
                str = [@"<c r=\"" mutableCopy];
                [str appendString:b[indexForB]];
                [str appendString:@"\" s=\"40\" t=\"s\"><v>"];
                [str appendString:[map valueForKey:_array[_tableSections.count-1][x]]];
                [str appendString:@"</v></c>"];
                
                xml1 = [[xml1 stringByReplacingCharactersInRange: NSMakeRange(i, k - i + 1) withString:str] mutableCopy];
                
                str = [@"" mutableCopy];
                indexForB++;
                nextPart = i;
                break;
            }
        }
    }
    //----------------------------------- end parsing parts inside action ------------------------------
    
    [xml1 writeToFile:filePath2 atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [self zip];
}

// convert from xlsx to zip
- (void)unzip {
    NSString *yourFileName = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *zipFilePath = [yourFileName stringByAppendingPathComponent:@"Workbook.xlsx"];
    NSString *output = [yourFileName stringByAppendingPathComponent:@"unZipDirName1"];
    
    ZipArchive* za = [[ZipArchive alloc] init];
    
    if ([za UnzipOpenFile:zipFilePath]) {
        if ( [za UnzipFileTo:output overWrite:YES] != NO ) {
            //unzip data success
            //do something
        }
        [za UnzipCloseFile];
    }
}

// convert from zip to xlsx
- (void)zip {
    BOOL isDir = NO;
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *subpaths;
    NSString *toCompress = @"unZipDirName1";
    NSString *pathToCompress = [documentsDirectory stringByAppendingPathComponent:toCompress];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathToCompress isDirectory:&isDir] && isDir == true) {
        subpaths = [fileManager subpathsAtPath:pathToCompress];
    }
    else {
        if ([fileManager fileExistsAtPath:pathToCompress]) {
            subpaths = [NSArray arrayWithObject:pathToCompress];
        }
    }
    
    NSMutableString *excelName = [[NSMutableString alloc] initWithString: _interview.idExternal.idCandidate.firstName];
    [excelName appendString:_interview.idExternal.idCandidate.lastName];
    [excelName appendString:[_cellDateFormatter stringFromDate:_interview.startDate]];
    excelName = [[excelName stringByReplacingOccurrencesOfString:@":" withString:@""] mutableCopy];
    
    NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@,.xlsx",excelName]];
    
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFilePath];
    if (isDir == true) {
        for(NSString *path in subpaths) {
            NSString *fullPath = [pathToCompress stringByAppendingPathComponent:path];
            if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir) {
                [za addFileToZip:fullPath newname:path];
            }
        }
    }
    else {
        [za addFileToZip:pathToCompress newname:toCompress];
    }
    
    [za CloseZipFile2];
}



@end

















