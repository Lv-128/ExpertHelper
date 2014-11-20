//
//  EHCandidateFormViewController.h
//  ExpertHelper
//
//  Created by alena on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHCandidateFormViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelNameOfCandidate;
@property (strong, nonatomic) NSString * nameOfCandidate;
@property (strong, nonatomic) NSString * lastnameOfCandidate;
@end
