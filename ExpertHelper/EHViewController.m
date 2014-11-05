//
//  EHViewController.m
//  ExpertHelper
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHViewController.h"

@interface EHViewController ()

@end

@implementation EHViewController

- (void)viewDidLoad
{
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [super viewDidLoad];
}

- (void)showAnimate
{
    self.popUpView.hidden = NO;
    self.popUpView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.popUpView.alpha = 0;
    [UIView animateWithDuration:.25 animations:^
     {
         self.popUpView.alpha = 1;
         self.popUpView.transform = CGAffineTransformMakeScale(1, 1);
     }];
}

- (void)removeAnimate
{
    
    [UIView animateWithDuration:.25 animations:^
     {
         self.popUpView.transform = CGAffineTransformMakeScale(1.0, 1.0);
         self.popUpView.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
         self.popUpView.hidden = YES;
     }];
}

- (IBAction)openPopup:(id)sender
{
    [self showAnimate];
}

- (IBAction)closePopup:(id)sender
{
    [self removeAnimate];
}

- (IBAction)colorswap:(id)sender
{
    self.view.backgroundColor=[UIColor blackColor];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
