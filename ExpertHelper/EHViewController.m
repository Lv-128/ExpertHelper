//
//  EHViewController.m
//  ExpertHelper
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHViewController.h"
#import "EHSkillLevelPopup.h"
<<<<<<< Updated upstream

@interface EHViewController ()<EHSkillLevelPopupDelegate>
=======
@interface EHViewController ()
>>>>>>> Stashed changes

@end

@implementation EHViewController

- (void)skillLevelPopupDelegate:(EHSkillLevelPopup *)popup didSelectLevel:(NSInteger)level {
    NSLog(@"Selected Level - %d", level);
}

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
    UINib *nib = [UINib nibWithNibName:@"EHSkillLevelPopup" bundle:nil];
<<<<<<< Updated upstream
    EHSkillLevelPopup *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
    CGRect r = self.view.frame;
    CGRect f = popup.frame;
    f.size.width = r.size.width;
    f.origin.y = r.size.height;
    popup.frame = f;
    popup.delegate = self;
    [self.view addSubview:popup];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect f = popup.frame;
        f.origin.y -= f.size.height;
        popup.frame = f;
    }];
    
//    [self showAnimate];
=======
    UIView *popup = [[nib instantiateWithOwner:nil options:nil] lastObject];
    
    popup.frame = CGRectMake(CGRectGetMinX(self.view.frame),CGRectGetMaxY(self.view.frame) - 404, 200, 300);
     
    [self.view addSubview:popup];
    
   //[self showAnimate];
>>>>>>> Stashed changes
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
