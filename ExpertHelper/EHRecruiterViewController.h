//
//  EHRecruiterViewController.h
//  ExpertHelper
//
//  Created by alena on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHRecruiterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelNameOfRecruiter;
@property (strong, nonatomic) NSString *nameOfRecruiter;
@property (strong, nonatomic) NSString *lastnameOfRecruiter;

- (IBAction)skypeMe:(id)sender;

@end
