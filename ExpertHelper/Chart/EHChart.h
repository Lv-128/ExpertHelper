//
//  EHChart.h
//  ExpertHelper
//
//  Created by alena on 12/18/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHRadarChart.h"

@interface EHChart : UIViewController

@property (nonatomic, copy) NSArray *points;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@end
