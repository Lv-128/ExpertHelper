//
//  EHCandidateFormViewController.m
//  ExpertHelper
//
//  Created by alena on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHCandidateFormViewController.h"

@interface EHCandidateFormViewController ()

@end

@implementation EHCandidateFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (id) init
{
    self = [super init];
    if (self) {
        _nameOfCandidate = @"Name: ";
        _lastnameOfCandidate = @"Last Name: ";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _labelNameOfCandidate.text = @"Name: ";
    _labelNameOfCandidate.text = [_labelNameOfCandidate.text stringByAppendingString:[_nameOfCandidate stringByAppendingString:[@" "stringByAppendingString:_lastnameOfCandidate]]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
