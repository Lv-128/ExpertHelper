//
//  EHITAViewController.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHITAViewController.h"
#import "EHITAViewControllerCell.h"

@interface EHITAViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *namesArray;
@property (nonatomic) NSMutableArray *checked;

@property (strong, nonatomic) UIImageView* imageView;


@end

@implementation EHITAViewController

@synthesize myPickerView,popoverController;
@synthesize scoreSrc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scoreSrc = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil]; //array which contains scores for candidate
    selectedScoreSrcIndex=0;
    
    
    _namesArray = [[NSArray alloc] initWithObjects: // array which contains names of candidate
                   @"Oleksandr Shymanskyi",
                   @"Nazar Vlizlo",
                   @"Olena Pyanih",
                   @"Taras Koval",nil];
    _checked = [[NSMutableArray alloc] init]; // array which check if candidate pass interview
    
    for (NSInteger i = 0; i < _namesArray.count; i++) {
        [_checked addObject:[NSNumber numberWithBool:false]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [_namesArray count];
}

//--------------- create custom cell of candidate in table ---------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ItaCell";
    EHITAViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[EHITAViewControllerCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.candidateName.text = [_namesArray objectAtIndex:row];
    cell.passLabel.text = @"Pass :";
    
    [cell.checkButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    cell.checkButton.tag = indexPath.row;
    [cell.checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.openPopUpButton setTitle:@"Select Score" forState:UIControlStateNormal];
    cell.openPopUpButton.layer.cornerRadius = 20;//half of the width
    cell.openPopUpButton.layer.borderColor=[UIColor grayColor].CGColor;
    cell.openPopUpButton.layer.borderWidth=2.0f;
    [cell.openPopUpButton addTarget:self action:@selector(openPopUpClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.commentButton setTitle:@"Add Comment" forState:UIControlStateNormal];
    cell.commentButton.layer.cornerRadius = 20;//half of the width
    cell.commentButton.layer.borderColor=[UIColor grayColor].CGColor;
    cell.commentButton.layer.borderWidth=2.0f;
    [cell.openPopUpButton addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];


    
    [cell.candidateImage setImage: [UIImage imageNamed:@"smile.png"] forState:UIControlStateNormal];
    [cell.candidateImage addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

//--------------- add expert's comment ---------------

-(void)addComment:(UIButton*)sender {
    button = (UIButton *)sender;
    
}

//--------------- choose picture for candidate ---------------

UIButton *button;

-(void)changeImage:(UIButton*)sender {
    button = (UIButton *)sender;
   
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
 
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    [self setImageForCell:image];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setImageForCell:(UIImage *)image {
    [button setImage:image forState:UIControlStateNormal];
}

//--------------- create PopUp with picker of scores ---------------

-(void)openPopUpClick:(UIButton*)sender {
    
    scoreOption = sender;
    
    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 260)];
    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:@"Select sсore"];
    
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [masterView addSubview:pickerToolbar];
    CGRect pickerFrame = CGRectMake(0, 40, 300, 216);
    UIPickerView *myPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    [myPicker setDataSource: self];
    [myPicker setDelegate: self];
    myPicker.tag=1;
    [myPicker selectRow:0 inComponent:0 animated:NO];
    [myPicker setShowsSelectionIndicator:YES];
    self.myPickerView=myPicker;
    [masterView addSubview:myPicker];
    
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view = masterView;

    viewController.preferredContentSize = viewController.view.frame.size;
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:viewController];
    
    UIButton *button = (UIButton *)sender;
    [self.popoverController presentPopoverFromRect:button.bounds
                                            inView:button
                          permittedArrowDirections:UIPopoverArrowDirectionDown
                                          animated:YES];
}

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    
    CGRect frame = CGRectMake(0, 0, 300, 44);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [self createButtonWithType:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [barItems addObject:flexSpace];
    if (title) {
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
    
}

- (IBAction)actionPickerDone:(id)sender {
    
    //[self notifyTarget:self.target didSucceedWithAction:self.successAction origin:[self storedOrigin]];
    
    if (self.popoverController && self.popoverController.popoverVisible)
        [self.popoverController dismissPopoverAnimated:YES];
}

- (IBAction)actionPickerCancel:(id)sender {
    
    if (self.popoverController && self.popoverController.popoverVisible)
        [self.popoverController dismissPopoverAnimated:YES];
    
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    [toolBarItemlabel setTextAlignment:NSTextAlignmentCenter];
    [toolBarItemlabel setTextColor:[UIColor whiteColor]];
    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
    toolBarItemlabel.text = aTitle;
    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
    return buttonLabel;
    
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([pickerView tag] == 1) {
        return [self.scoreSrc count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        return [self.scoreSrc objectAtIndex:row];
        
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([pickerView tag] == 1) {
        selectedScoreSrcIndex=row;
        selectedScore=[self.scoreSrc objectAtIndex:selectedScoreSrcIndex];
        [scoreOption setTitle:selectedScore forState:UIControlStateNormal];
    }
}

//--------------- check if candidate has passed iterview ---------------

-(void)checkButtonClicked:(UIButton*)sender {
    UIButton *btn = (UIButton *)sender;
    int index = [btn tag];
    
    if (![[_checked objectAtIndex:index] boolValue]) {
        [sender setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [_checked replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:true]];
    } else {
        [sender setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        [_checked replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:false]];
    }
}

@end
