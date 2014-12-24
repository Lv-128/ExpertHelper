
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
#import "EHCandidateProfileViewController.h"
#import "EHChart.h"
#import "EHGeneralInfoCell.h"


@interface EHExternalViewController () <UITableViewDataSource, UITableViewDelegate, EHSkillLevelPopupDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSections;
@property (nonatomic, strong) NSArray *sectionContent;
@property (nonatomic, strong) NSArray *arrayOfRecordsUrl;
@property (nonatomic, strong) NSArray *arrayOfRecordsString;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *comment;
@property (nonatomic, strong) EHSkillsProfilesParser *pars;
@property (nonatomic, strong) EHRecorderCommentController *recorderComment;
@property (nonatomic, strong) EHGenInfo *generInfo;
@property (nonatomic, strong) EHSkillLevelPopup *popup;
@property (strong, nonatomic) UIActionSheet *actionSheetMenu;

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
    [popup close];
    self.popup = nil;
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
    
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", NSHomeDirectory());
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"EHGeneralInfoCellIpad" bundle:nil]
             forCellReuseIdentifier:@"GeneralInfoIpad"];
    }
    else
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"EHGeneralInfoCellIphone" bundle:nil]
             forCellReuseIdentifier:@"GeneralInfoIphone"];
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", _interview.idExternal.idCandidate.firstName,
                                 _interview.idExternal.idCandidate.lastName];
    
    
    
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterLongStyle];
    newCell = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableSections = @[@"General info", @"Design", @"Construction", @"Quality", @"Configuration Management", @"Scope Management and Software Engineering", @"Profiles"];
    self.sectionContent = @[@[],
                            @[ @"Object oriented programming and design", @"Designing solution architecture", @"Database design" ],
                            @[ @"Coding (primary language and standard libraries)", @"Debugging and bug fixing" ],
                            @[ @"Using issue tracking systems", @"Reviewing code" ],
                            @[ @"Versions management", @"Build management" ],
                            @[ @"Gathering and managing requirements", @"Preparing estimations", @"Writing proposals" ],
                            @[ @"Core", @"Desktop", @"Web", @"DB", @"BI", @"RIA", @"Multimedia", @"Mobile", @"Embedded", @"Integration" ]];
    
    _array = [[NSMutableArray alloc]initWithCapacity:0];
    _comment = [[NSMutableArray alloc]initWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGeninfo:)
                                                name:@"GetInfo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getrecorderComment:)
                                                name:@"RecorderComment" object:nil];
    
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
        
        for (int i = 0; i < myArr.count; i++)
        {
            NSMutableArray *tt = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray *tr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int b =0; b<[self.sectionContent[i]count];b++)
            {
                for(int j = 0; j < [myArr[i]count];j++)
                {
                    if ([[myArr[i][j] nameOfSkill] isEqualToString:self.sectionContent[i][b]])
                    {
                        [tt addObject:[myArr[i][j] estimate]];
                        EHSkill *kkk=myArr[i][j];
                        [tr addObject:[kkk comment]];
                    }
                }
            }
            [_array insertObject:tt atIndex:i];
            [_comment insertObject:tr atIndex:i];
        }
        _generInfo = _pars.genInfo;
        _arrayOfRecordsString = _pars.recordsNames;
        _arrayOfRecordsUrl = _pars.recordsUrls;
    }
    else{
        for (int i = 0; i < self.tableSections.count; i++)//6
        {
            NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:0];// group]
            NSMutableArray *temp2 = [[NSMutableArray alloc]initWithCapacity:0];
            for (int b = 0; b < [[self.sectionContent objectAtIndex:i] count]; b++){
                [temp2 addObject:@""];
                [temp addObject:@""];
            }
            [_array insertObject:temp atIndex:i];
            [_comment insertObject:temp2 atIndex:i];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *generalInfoIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[generalInfoIndex] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark Send Email To Recruiter
- (void)sendEmailToAddressWithUrl:(NSString *)url fileName:(NSString *)fileName{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    
    NSArray *addressArray = [[NSArray alloc]initWithObjects:@"", nil];
    [mailController setMessageBody:@"Print message here!" isHTML:NO];
    //attachment
    NSData *fileData = [NSData dataWithContentsOfFile:url];
    if (fileData != nil)
    {
        [mailController addAttachmentData:fileData mimeType:@"document/xls" fileName:fileName];
        [mailController setToRecipients:addressArray];
        [mailController setSubject:@""];
        [mailController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:mailController animated:YES completion: nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *) controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Work with Action sheet

- (IBAction)pressMenu:(id)sender
{
    
    _actionSheetMenu = [[UIActionSheet alloc] initWithTitle:@"Select type of interview:"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"Export to XLS", @"Send via Email", @"Chart",nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [_actionSheetMenu showFromBarButtonItem:sender animated:YES];
    }
    else
        [_actionSheetMenu showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self saveFormZip];
        UIAlertView *message  = [[UIAlertView alloc] initWithTitle:@""
                                                           message:@"Export to .xlsx successed!"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [message show];
    }
    if(buttonIndex == 1)
    {
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        NSMutableString *excelName = [[NSMutableString alloc]
                                      initWithString: _interview.idExternal.idCandidate.firstName];
        [excelName appendString:_interview.idExternal.idCandidate.lastName];
        [excelName appendString:[_cellDateFormatter stringFromDate:_interview.startDate]];
        excelName = [[excelName stringByReplacingOccurrencesOfString:@":" withString:@""] mutableCopy];
        
        NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:
                                 [NSString stringWithFormat: @"%@,.xlsx",excelName]];
        [self sendEmailToAddressWithUrl:zipFilePath fileName:excelName];
    }
    if(buttonIndex == 2)
    {
        EHChart *chartForm = [self.storyboard instantiateViewControllerWithIdentifier:@"ChartView"];
        
        int size = self.view.frame.size.width > self.view.frame.size.height ? self.view.frame.size.height :
        self.view.frame.size.width;
        chartForm.points = _array.lastObject;
        chartForm.titles = _sectionContent.lastObject;
        
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            chartForm.width = size * 0.9;
            chartForm.height = size * 0.9;
            self.popover = [[UIPopoverController alloc] initWithContentViewController:chartForm];
            self.popover.popoverContentSize = CGSizeMake(size * 0.9, size * 0.9);
            
            [self.popover presentPopoverFromBarButtonItem:_barButMenu
                                 permittedArrowDirections:UIPopoverArrowDirectionUp
                                                 animated:YES];
        }
        else
        {
            chartForm.width = size * 1.21;
            chartForm.height = size * 1.21;
            
            [self.navigationController pushViewController:chartForm animated:YES];
        }
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        NSLog(@"Back pressed");
        [self parsFunc];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_popup close];
    
    if ([[segue identifier] isEqualToString:@"GoToGenInfoForm"])
    {
        EHCandidateProfileViewController *genInfoForm = [segue destinationViewController];
        genInfoForm.genInfo = _generInfo;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableSections count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    return [self.sectionContent[section]count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create custom view to display section header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), 18.0)];
    //create custom class!
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), 18.0)];
    [labelLeft setFont:[UIFont boldSystemFontOfSize:15]];
    [labelLeft setTextAlignment:NSTextAlignmentCenter];
    
    labelLeft.text = [self.tableSections objectAtIndex:section];
    
    [view addSubview:labelLeft];
    [view setBackgroundColor:[UIColor colorWithRed:166 / 255.0 green:177 / 255.0 blue:186 / 255.0 alpha:1.0]];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSArray *listData = [self.sectionContent objectAtIndex:[indexPath section]];
    NSString *cellIdentifier;
    
    if (indexPath.section == 0)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            cellIdentifier = @"GeneralInfoIpad";
        else
            cellIdentifier = @"GeneralInfoIphone";
        
        EHGeneralInfoCell *cell = (EHGeneralInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell.genInfo == nil)
        {
            cell.genInfo = [[EHGenInfo alloc] init];
        }
        else
        {
            cell.expertName.text = self.generInfo.expertName;
            //  self.dateLabel.text = _genInfo.dateOfInterview;
            cell.competenceGroup.text = self.generInfo.competenceGroup;
            cell.typeOfProject.text = self.generInfo.typeOfProject;
            cell.skillSummary.text = self.generInfo.skillsSummary;
            cell.englishLabel.text = self.generInfo.techEnglish;
            cell.recomendations.text = self.generInfo.recommendations;
            cell.levelEstimateLabel.text = self.generInfo.levelEstimate;
            cell.highPotentionalLabel.text = self.generInfo.potentialCandidate;
            cell.switchView.on = self.generInfo.hire;
            
        }
        return cell;
    }
    else
    {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 502.0;
    return 72.0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    //    [self performSegueWithIdentifier:@"profa" sender:cell];
    
    self.recorderComment = [self.storyboard instantiateViewControllerWithIdentifier:@"RecorderComment"];
    
    self.recorderComment.level = _array;
    self.recorderComment.index = _index;
    self.recorderComment.comment = _comment;
    self.recorderComment.arrayOfRecordsString = _arrayOfRecordsString;
    self.recorderComment.arrayOfRecordsUrl = _arrayOfRecordsUrl;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        self.recorder = [[UIPopoverController alloc] initWithContentViewController:self.recorderComment];
        self.recorder.popoverContentSize = CGSizeMake(700.0, 700.0);
        
        CGRect rect = CGRectMake(cell.frame.size.width - 50, cell.frame.origin.y, 70, 10);
        
        [self.recorder presentPopoverFromRect:rect
                                       inView:self.tableView
                     permittedArrowDirections:UIPopoverArrowDirectionRight
                                     animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:self.recorderComment animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"GoToGenInfoForm" sender:self];
    }
    else
    {
        NSUInteger row = [indexPath row];
        
        lostData = [indexPath section];
        RowAtIndexPathOfSkills = row;
        
        if (_popup == nil){
            NSString *nibName;
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
                nibName = @"EHSkillLevelPopupIpad";
            else
                nibName = @"EHSkillLevelPopupIphone";
            
            UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
            EHSkillLevelPopup *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
            [popup showInView:self.view];
            popup.delegate = self;
            popup.titleLabel.text = @"Select the desired level";
            self.popup = popup;
        } else {
            [_popup close];
            self.popup = nil;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popup close];
    self.popup = nil;
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
                skillsOfExternal.comment = _comment[y][x];
            }
            else {
                skillsOfExternal.comment = @"";
                _comment[y][x] = @"";
            }
            [groupsTransmitting addObject:skillsOfExternal];
        }
        groupsOfExternal.skills = groupsTransmitting;
        groupsOfExternal.nameOfSections = _tableSections[y];
        [profTransmitting addObject:groupsOfExternal];
    }
    
    if (_generInfo == nil)
    {
        _generInfo = [[EHGenInfo alloc]init];
    }
    if (_generInfo.expertName == NULL)
        _generInfo.expertName = @"None";
    if (_generInfo.competenceGroup == NULL)
        _generInfo.competenceGroup = @"None";
    if (_generInfo.typeOfProject == NULL)
        _generInfo.typeOfProject = @"None";
    if (_generInfo.skillsSummary == NULL)
        _generInfo.skillsSummary = @"None";
    if (_generInfo.techEnglish == NULL)
        _generInfo.techEnglish = @"None";
    if (_generInfo.recommendations == NULL)
        _generInfo.recommendations = @"None";
    _pars = [[EHSkillsProfilesParser alloc]initWithDataGroups:profTransmitting
                                                 andInterview:_interview
                                                   andGenInfo:_generInfo
                                           andRecordsNamesArr:self.arrayOfRecordsString
                                                andRecordsUrl:self.arrayOfRecordsUrl];
    [_pars saveInfoToDB];
}

- (void)getGeninfo:(NSNotification *)notification
{
    self.generInfo = notification.userInfo[@"genInfo"];
    
}

- (void)getrecorderComment:(NSNotification *)notification
{
    self.recorderComment = notification.userInfo[@"recorderComment"];
    self.array = notification.userInfo[@"recorderLevel"];
    self.arrayOfRecordsString = notification.userInfo[@"recorderName"];
    self.arrayOfRecordsUrl = notification.userInfo[@"recorderUrl"];
    
    [self.tableView reloadData];
}

- (void)saveFormZip {
    [self parsFunc];
    [self unzip];
    
    [self insertIntoExclesSharedString];
    
    [self writeToSheet3Score];
    [self writeToSheet4Score];
 
    [self zip];
}

// convert from xlsx to zip
- (void)unzip {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Workbook" ofType:@"xlsx"];
    
    NSString *yourFileName = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //  NSString *zipFilePath = [yourFileName stringByAppendingPathComponent:@"Workbook.xlsx"];
    NSString *output = [yourFileName stringByAppendingPathComponent:@"unZipDirName1"];
    
    ZipArchive* za = [[ZipArchive alloc] init];
    
    if ([za UnzipOpenFile:filePath]) {
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
- (void) insertIntoExclesSharedString {
    NSError *error;
    
    NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"unZipDirName1"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"xl"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"sharedStrings.xml"];
    NSMutableString* xml = [[NSMutableString alloc] initWithString:[NSMutableString stringWithContentsOfFile:filePath1 encoding:NSUTF8StringEncoding error:&error]];
    int uniqueCountIndex = 295;
    
    for (int i = 0; i < _comment.count; i++) {
        for (int j = 0; j < [_comment[i] count]; j++) {
            if (![_comment[i][j] isEqualToString:@""]) {
                uniqueCountIndex++;
            }
        }
    }
    
    NSMutableString *stringForComparing = [@"</sst>" mutableCopy];
    int k = 0;
    
    NSMutableString *stringForComparing1 = [@"uniqueCount=\"" mutableCopy];
    
    for (int i = 0; i < xml.length - 14; i++) {
        NSString *s = [xml substringWithRange:NSMakeRange(i, 13)];
        if ([s isEqualToString:stringForComparing1]) {
            xml = [[xml stringByReplacingCharactersInRange: NSMakeRange(i+13, 3) withString:[NSString stringWithFormat:@"%d",uniqueCountIndex]] mutableCopy];
            break;
        }
    }
    
    for (int i = 0; i < xml.length - 5; i++) {
        
        NSString *ss = [xml substringWithRange:NSMakeRange(i, 6)];
        if ([ss isEqualToString:stringForComparing]) {
            k = i;
            
            //     [xml insertString:@"<si><t>Strong</t></si>" atIndex:k];
            //     [xml insertString:@"<si><t>Good</t></si>" atIndex:k];
            //      [xml insertString:@"<si><t>Beginner</t></si>" atIndex:k];
            //       [xml insertString:@"<si><t>None</t></si>" atIndex:k];
            for (int ii = 0; ii < _comment.count; ii++) {
                for (int j = 0; j < [_comment[ii] count]; j++) {
                    if (![_comment[ii][j] isEqualToString:@""]) {
                        NSString *s =@"<si><t>";
                        s = [s stringByAppendingString:_comment[ii][j]];
                        s = [s stringByAppendingString:@"</t></si>"];
                        
                        [xml insertString:s atIndex:k];
                    }
                }
            }
            break;
        }
        
    }
    
    
    [xml writeToFile:filePath1 atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (void) writeToSheet3Score {
    NSError *error;
    
    NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"unZipDirName1"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"xl"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"worksheets"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"sheet3.xml"];
    NSMutableString* xml = [[NSMutableString alloc] initWithString:[NSMutableString stringWithContentsOfFile:filePath1 encoding:NSUTF8StringEncoding error:&error]];
    
    NSArray *a = [[NSArray alloc] initWithObjects:@"E21", @"E22", @"E23", @"E25", @"E26", @"E28", @"E29", @"E31", @"E32", @"E34", @"E35", @"E36", nil];
    NSArray *b = [[NSArray alloc] initWithObjects:@"F21", @"F22", @"F23", @"F25", @"F26", @"F28", @"F29", @"F31", @"F32", @"F34", @"F35", @"F36", nil];
    int indexForA = 0;
    
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
                NSString *ss = [xml substringWithRange:NSMakeRange(i, 10)];
                if ([ss isEqual:stringForComparing]) {
                    int k = 0;
                    for (int j = i + 10; j < xml.length - 10; j++) {
                        if ([xml characterAtIndex:j] == '/') {
                            k = j + 1;
                            break;
                        }
                    }
                    
                    NSMutableString *str = [@"<c r=\"" mutableCopy];
                    [str appendString:a[indexForA]];
                    [str appendString:@"\" s=\"105\" t=\"s\"><v>"];
                    [str appendString:[map valueForKey:_array[y][x]]];
                    [str appendString:@"</v></c>"];
                    
                    xml = [[xml stringByReplacingCharactersInRange: NSMakeRange(i, k - i + 1) withString:str] mutableCopy];
                    
                    indexForA++;
                    nextPart = i;
                    break;
                    
                }
            }
        }
    }
    
    // wriring comments
    
    nextPart = 0;
    indexForA = 0;
    
    for (int y = 0; y < _tableSections.count; y++) {
        if (indexForA >= 12) break;
        for (int x = 0; x < [[self.sectionContent objectAtIndex:y] count]; x++) {
            if (![_comment[y][x] isEqualToString:@""]) {
                stringForComparing = @"<c r=\"";
                stringForComparing = [stringForComparing stringByAppendingString:b[indexForA]];
                stringForComparing = [stringForComparing stringByAppendingString:@"\""];
                
                for (int i = nextPart; i < xml.length - 10; i++) {
                    NSString *ss = [xml substringWithRange:NSMakeRange(i, 10)];
                    if ([ss isEqual:stringForComparing]) {
                        int k = 0;
                        for (int j = i + 10; j < xml.length - 10; j++) {
                            if ([xml characterAtIndex:j] == '/') {
                                k = j + 1;
                                break;
                            }
                        }
                        
                        NSMutableString *str = [@"<c r=\"" mutableCopy];
                        [str appendString:b[indexForA]];
                        [str appendString:@"\" s=\"105\" t=\"s\"><v>"];
                        [str appendString:_comment[y][x]];
                        [str appendString:@"</v></c>"];
                        
                        xml = [[xml stringByReplacingCharactersInRange: NSMakeRange(i, k - i + 1) withString:str] mutableCopy];
                        
                        nextPart = i;
                        break;
                    }
                }
            }
            indexForA++;
        }
    }
    
    [xml writeToFile:filePath1 atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (void) writeToSheet4Score {
    NSError *error;
    
    NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"unZipDirName1"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"xl"];
    filePath1 = [filePath1 stringByAppendingPathComponent:@"worksheets"];
    NSString *filePath2 = [filePath1 stringByAppendingPathComponent:@"sheet4.xml"];
    
    NSString *stringForComparing;
    
    NSMutableString* xml1 = [[NSMutableString alloc] initWithString:[NSMutableString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:&error]];
    
    NSArray *b = [[NSArray alloc] initWithObjects:@"B8", @"C8", @"D8", @"E8", @"F8", @"G8", @"H8", @"I8", @"J8", @"K8", nil];
    NSDictionary *map= [[NSDictionary alloc] initWithObjectsAndKeys:@"291", @"None", @"292", @"Low", @"293", @"Middle", @"294", @"Strong", nil];
    int indexForB = 0;
    int nextPart = 0;
    for (int x = 0; x < [[self.sectionContent objectAtIndex:_tableSections.count-1] count]; x++) {
        stringForComparing = @"<c r=\"";
        stringForComparing = [stringForComparing stringByAppendingString:b[indexForB]];
        stringForComparing = [stringForComparing stringByAppendingString:@"\""];
        //ss=@"";
        for (int i = nextPart; i < xml1.length - 9; i++) {
            if (indexForB >= 10) break;
            NSString *ss = [xml1 substringWithRange:NSMakeRange(i, 9)];
            if ([ss isEqual:stringForComparing]) {
                int k = 0;
                for (int j = i + 10; j < xml1.length - 9; j++) {
                    if ([xml1 characterAtIndex:j] == '/') {
                        k = j + 1;
                        break;
                    }
                }
                
                NSMutableString *str = [@"<c r=\"" mutableCopy];
                [str appendString:b[indexForB]];
                [str appendString:@"\" s=\"40\" t=\"s\"><v>"];
                [str appendString:[map valueForKey:_array[_tableSections.count-1][x]]];
                [str appendString:@"</v></c>"];
                
                xml1 = [[xml1 stringByReplacingCharactersInRange: NSMakeRange(i, k - i + 1) withString:str] mutableCopy];
                
                
                indexForB++;
                nextPart = i;
                break;
            }
        }
    }
    
    [xml1 writeToFile:filePath2 atomically:YES encoding:NSUTF8StringEncoding error:&error];
}


@end






