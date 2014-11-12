//
//  EHViewController.h
//  ExpertHelper
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;


- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (IBAction)closePopup:(id)sender;
- (IBAction)openPopup:(id)sender;
- (IBAction)colorswap:(id)sender;

@end
