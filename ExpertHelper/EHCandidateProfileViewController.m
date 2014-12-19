//
//  EHCandidateProfileViewController.m
//  ExpertHelper
//
//  Created by nvlizlo on 10.12.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHCandidateProfileViewController.h"
#import "EHSkillsProfilesParser.h"
#import "EHRoundedAngleTextField.h"
#import "EHRoundedTextView.h"


@interface EHCandidateProfileViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSDateFormatter *formatter;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *englishTexField;
@property (weak, nonatomic) IBOutlet UITextField *highPotentionalTextField;
@property (weak, nonatomic) IBOutlet UITextField *levelEstimateTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@property (strong, nonatomic) UIPickerView *englishPicker;
@property (strong, nonatomic) UIPickerView *highPotentionalPicker;
@property (strong, nonatomic) UIPickerView *levelEstimatePicker;

@property (copy, nonatomic) NSArray *englishArray;
@property (copy, nonatomic) NSArray *highPotentionalArray;
@property (copy, nonatomic) NSArray *levelEstimateArray;

@property (weak, nonatomic) IBOutlet EHRoundedAngleTextField *expertName;
@property (weak, nonatomic) IBOutlet EHRoundedTextView *competenceGroup;
@property (weak, nonatomic) IBOutlet EHRoundedTextView *skillSummary;
@property (weak, nonatomic) IBOutlet EHRoundedAngleTextField *typeOfProject;
@property (weak, nonatomic) IBOutlet EHRoundedAngleTextField *recomendations;


@end

@implementation EHCandidateProfileViewController

- (NSDateFormatter *)formatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"dd-MM-yyyy";
    }
    return _formatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateLabel.text = [self.formatter stringFromDate:[NSDate date]];
    [self configureArrays];
    [self configureTextFields];
    
    if(_genInfo == nil)
    {
        _genInfo = [[EHGenInfo alloc]init];
    } else {
        self.expertName.text = _genInfo.expertName;
        self.competenceGroup.text = _genInfo.competenceGroup;
        self.typeOfProject.text = _genInfo.typeOfProject;
        self.skillSummary.text = _genInfo.skillsSummary;
        self.englishTexField.text = _genInfo.techEnglish;
        self.recomendations.text = _genInfo.recommendations;
        self.switchView.on = _genInfo.hire;
    }
	// Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    (![self.expertName.text isEqualToString:@""]) ? (_genInfo.expertName = self.expertName.text): (_genInfo.expertName = @"None");
    _genInfo.dateOfInterview = [NSDate date];
    (![self.competenceGroup.text isEqualToString:@""]) ? (_genInfo.competenceGroup = self.competenceGroup.text): (_genInfo.competenceGroup = @"None");
    (![self.typeOfProject.text isEqualToString:@""]) ? (_genInfo.typeOfProject = self.typeOfProject.text): (_genInfo.typeOfProject = @"None");
    (![self.skillSummary.text isEqualToString:@""]) ? (_genInfo.skillsSummary = self.skillSummary.text): (_genInfo.skillsSummary = @"None");
    (![self.englishTexField.text isEqualToString:@""]) ? (_genInfo.techEnglish = self.englishTexField.text): (_genInfo.techEnglish = @"None");
    (![self.recomendations.text isEqualToString:@""]) ? (_genInfo.recommendations = self.recomendations.text): (_genInfo.recommendations = @"None");
    (![self.highPotentionalTextField.text isEqualToString:@""]) ? (_genInfo.potentialCandidate = self.highPotentionalTextField.text): (_genInfo.potentialCandidate = @"None");
    (![self.levelEstimateTextField.text isEqualToString:@""]) ? (_genInfo.levelEstimate = self.levelEstimateTextField.text): (_genInfo.levelEstimate = @"None");
    _genInfo.hire = self.switchView.on;
    NSDictionary *dict = [NSDictionary dictionaryWithObject:_genInfo forKey:@"genInfo"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GetInfo" object:nil userInfo:dict];
}

- (void)configureArrays
{
    NSArray *level = @[@" high", @" low"];
    self.englishArray = @[@[@"basic ", @"intermediate ",@"Advanced "], level];
    self.levelEstimateArray = @[@[@"junior ", @"intermediate ", @"senior ", @"leader "], level];
    self.highPotentionalArray = @[@"low", @"regular", @"high"];
}

- (void)configureTextFields
{
    //[self insertPickerView:self.englishPicker inTextField:self.englishTexField withTag:1];
    [self insertPickerView:self.levelEstimatePicker inTextField:self.levelEstimateTextField withTag:2];
    [self insertPickerView:self.highPotentionalPicker inTextField:self.highPotentionalTextField withTag:3];
}

- (void)insertPickerView:(UIPickerView *)pickerView inTextField:(UITextField *)textField withTag:(NSInteger)tag
{
    pickerView = [[UIPickerView alloc] init];
    pickerView.tag = tag;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    textField.delegate = self;
    textField.tag = tag;
    textField.inputView = pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (pickerView.tag) {
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:
            if (component == 0)
                return 3;
            else
                return 2;
            break;
        case 2:
            if (component == 0)
                return 4;
            else
                return 2;
            break;
        case 3:
            return 3;
        default:
            return 3;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:
            return self.englishArray[component][row];
            break;
        case 2:
            return self.levelEstimateArray[component][row];
            break;
        case 3:
            return self.highPotentionalArray[row];
        default:
            return @"?";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:
            [self fillTextField:self.englishTexField withArray:self.englishArray inComponent:component andRow:row];
            break;
        case 2:
            [self fillTextField:self.levelEstimateTextField
                      withArray:self.levelEstimateArray
                    inComponent:component
                         andRow:row];
            break;
        case 3:
            self.highPotentionalTextField.text = self.highPotentionalArray[row];
            
        default:
            break;
    }
}

- (void)fillTextField:(UITextField *)textField
            withArray:(NSArray *)array
          inComponent:(NSInteger)component
               andRow:(NSInteger)row
{
    if ([textField.text isEqualToString:@""])
        textField.text = array[component][row];
    else
    {
        if (component == 0)
        {
            NSInteger location = [textField.text rangeOfString:@" "].location + 1;
            textField.text = [textField.text stringByReplacingOccurrencesOfString:[textField.text substringToIndex:location]
                                                                       withString:array[0][row]];
        }
        else
        {
            NSInteger location = [textField.text rangeOfString:@" "].location;
            textField.text = [textField.text stringByReplacingOccurrencesOfString:[textField.text substringFromIndex:location]
                                                                       withString:array[1][row]];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.englishTexField resignFirstResponder];
    [self.highPotentionalTextField resignFirstResponder];
    [self.levelEstimateTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (([textField.text isEqualToString:@""]))
    {
        if (textField.tag == 2)
        {
            textField.text = self.levelEstimateArray[0][0];
            textField.text = [textField.text stringByAppendingString:[self.levelEstimateArray[1][0] substringFromIndex:1]];
        }
        else
            textField.text = self.highPotentionalArray[0];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
