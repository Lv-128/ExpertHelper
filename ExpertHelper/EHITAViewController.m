//
//  EHITAViewController.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHITAViewController.h"
#import "EHITAViewControllerCell.h"
#import "EHAddITACandidatesViewController.h"

@interface EHITAViewController ()

@property (nonatomic, strong) EHAddITACandidatesViewController *addCandidates;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *namesArray;
@property (nonatomic, copy) NSArray *scope;
@property (copy) NSMutableArray *checked;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation EHITAViewController

@synthesize myPickerView, popoverController;
@synthesize scoreSrc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([_interview.type integerValue] == 1)
    {
        if (_interview.idITAInterview.itaGroupName == nil)
            self.navigationItem.title = [NSString stringWithFormat:@"Interview with ITA-Group"];
        else
            self.navigationItem.title = [NSString stringWithFormat:@"Interview with %@", _interview.idITAInterview.itaGroupName];
    }
    
    _scope = [NSArray arrayWithObjects:@"00", @"05", @"10", @"15", @"20", @"25",@"30", @"35", @"40", @"45", @"50", @"55", @"60", @"65", @"70", @"75", @"80", @"85", @"90", @"95", nil];
    self.scoreSrc = [NSArray arrayWithObjects:@[@"1", @"2", @"3", @"4", @"5",], _scope, nil]; //array which contains scores for candidate
    
    _namesArray = [[NSArray alloc] initWithObjects: // array which contains names of candidate
                   @"Oleksandr Shymanskyi",
                   @"Nazar Vlizlo",
                   @"Olena Pyanih",
                   @"Taras Koval",nil];
    _checked = [[NSMutableArray alloc] init]; // array which check if candidate pass interview
    
    for (NSInteger i = 0; i < _namesArray.count; i++)
        [_checked addObject:[NSNumber numberWithBool:false]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - tableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [_interview.idITAInterview.candidatesSet count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHITAViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItaCell"];
    
    if (!cell) {
        cell = [[EHITAViewControllerCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"ItaCell"];
    }
    
    NSUInteger row = [indexPath row];
    
    NSArray *arr = [_interview.idITAInterview.candidatesSet allObjects];
    cell.candidateName.text = [NSString stringWithFormat:@"%@ %@", [[arr objectAtIndex:row]firstName], [[arr objectAtIndex:row]lastName]];
    
    NSArray *array = self.interview.idITAInterview.scores;
    
    if (array.count > 0)
        [cell.openPopUpButton setTitle:[array objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    else
    [cell.openPopUpButton setTitle:@"Select Score" forState:UIControlStateNormal];

    
    cell.openPopUpButton.layer.cornerRadius = 20;//half of the width
    cell.openPopUpButton.layer.borderColor = [UIColor grayColor].CGColor;
    cell.openPopUpButton.layer.borderWidth = 2.0f;
    
    [cell.openPopUpButton addTarget:self action:@selector(openPopUpClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.candidateImage setImage:[UIImage imageNamed:@"smile.png"] forState:UIControlStateNormal];
    [cell.candidateImage addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


# pragma mark - choose picture for candidate

UIButton *button;

- (void)changeImage:(UIButton *)sender
{
    button = (UIButton *)sender;
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [self setImageForCell:image];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setImageForCell:(UIImage *)image
{
    [button setImage:image forState:UIControlStateNormal];
}

# pragma mark - create PopUp with picker of scores

- (NSIndexPath *)indexPathOfButton:(UIButton *)button {
    UIView *view = button.superview;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    return [_tableView indexPathForCell:(UITableViewCell *)view];
}


- (void)openPopUpClick:(UIButton *)sender
{
    _indexPath = [self indexPathOfButton:sender];
    
    scoreOption = sender;
    
    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 260)];
    
    CGRect pickerFrame = CGRectMake(0, 40, 300, 216);
    UIPickerView *myPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    [myPicker setDataSource:self];
    [myPicker setDelegate:self];
    myPicker.tag = 1;
    
    if ([sender.titleLabel.text isEqualToString:@"Select Score"])
    {
        selectedScore = [[[self.scoreSrc objectAtIndex:0]objectAtIndex:0] stringByAppendingString:[@"." stringByAppendingString:[[self.scoreSrc objectAtIndex:1]objectAtIndex:0]]];
        [scoreOption setTitle:selectedScore forState:UIControlStateNormal];
    } else {
        scopeCount = [[sender.titleLabel.text substringToIndex:1] integerValue];
        
        for (int i = 0; i < _scope.count; i++) {
            NSString *checkString = [[NSString alloc]initWithString:[sender.titleLabel.text substringFromIndex:2]];
            
            if ([checkString isEqual:_scope[i]])
                scopeCount2 = i;
            
            [myPicker selectRow:scopeCount - 1 inComponent:0 animated:NO];
            [myPicker selectRow:scopeCount2 inComponent:1 animated:NO];
        }
    }
    
    [myPicker setShowsSelectionIndicator:YES];
    self.myPickerView = myPicker;
    [masterView addSubview:myPicker];
    
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view = masterView;
    
    viewController.preferredContentSize = viewController.view.frame.size;
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    
    UIButton *button = (UIButton *)sender;
    [self.popoverController presentPopoverFromRect:button.bounds
                                            inView:button
                          permittedArrowDirections:UIPopoverArrowDirectionDown
                                          animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag && component == 0)
        return [[self.scoreSrc objectAtIndex:0] count];
    
    if (pickerView.tag && component == 1){
        if ([[selectedScore substringToIndex:1]integerValue] >= 5) {
            return 1;
        } else
            return [[self.scoreSrc objectAtIndex:1] count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag && component == 0)
        return [[self.scoreSrc objectAtIndex:0]objectAtIndex:row];
    
    if (pickerView.tag && component == 1)
        return [[self.scoreSrc objectAtIndex:1]objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    EHITAViewControllerCell *cell = (EHITAViewControllerCell *)[_tableView cellForRowAtIndexPath:_indexPath];
    
    if (pickerView.tag)
        selectedScore = [[[self.scoreSrc objectAtIndex:0]objectAtIndex:(int)[pickerView selectedRowInComponent:0]]
                         stringByAppendingString:[@"."
                                                  stringByAppendingString:[[self.scoreSrc objectAtIndex:1]objectAtIndex:(int)[pickerView selectedRowInComponent:1]]]];
    
    if ([[selectedScore substringToIndex:1]integerValue] < 3)
        cell.pass.on = NO;
    else
        cell.pass.on = YES;
    
    if ([[selectedScore substringToIndex:1]integerValue] >= 5)
        [pickerView selectRow:0 inComponent:1 animated:NO];
    
    if (pickerView.tag)
        selectedScore = [[[self.scoreSrc objectAtIndex:0]objectAtIndex:(int)[pickerView selectedRowInComponent:0]]
                         stringByAppendingString:[@"."
                                                  stringByAppendingString:[[self.scoreSrc objectAtIndex:1]objectAtIndex:(int)[pickerView selectedRowInComponent:1]]]];
    
    [pickerView reloadAllComponents];
    
    [scoreOption setTitle:selectedScore forState:UIControlStateNormal];
}

# pragma mark - add candidates

- (IBAction)addITACandidate:(id)sender
{
    self.addCandidates = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCandidates"];
    
    if (self.popover.isPopoverVisible)
        [self.popover dismissPopoverAnimated:YES];
    else
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            self.addCandidates.interview = self.interview;
            self.popover = [[UIPopoverController alloc] initWithContentViewController:self.addCandidates];
            self.popover.popoverContentSize = CGSizeMake(300.0, 300.0);
            self.popover.delegate = self;
            [self.popover presentPopoverFromBarButtonItem:_zoomButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        else
            [self.navigationController pushViewController:self.addCandidates animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSMutableArray *scores = [[NSMutableArray alloc]init];
    for (int i = 0; i < [_interview.idITAInterview.candidatesSet count]; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        EHITAViewControllerCell *cell = (EHITAViewControllerCell *)[_tableView cellForRowAtIndexPath:index];
        NSLog(@"%@",cell.openPopUpButton.titleLabel.text);
        NSLog(@"%@",cell.candidateName.text);
        [scores addObject:cell.openPopUpButton.titleLabel.text];
    }
    self.interview.idITAInterview.scores = scores;
}

@end









