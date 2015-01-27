//
//  EHChart.m
//  ExpertHelper
//
//  Created by alena on 12/18/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHChart.h"

@implementation EHChart
{
    EHRadarChart *p2;
    int borderSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    borderSize = 25;
    
    p2 = [[EHRadarChart alloc] initWithFrame:CGRectMake(borderSize, borderSize, _width  - borderSize * 2 , _height - borderSize * 2)];
    p2.centerPoint = CGPointMake((_width - 2 * borderSize) / 2, (_height - 2 * borderSize) / 2);
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        p2.centerPoint = CGPointMake(p2.centerPoint.x - 45, p2.centerPoint.y);
    
    p2.backgroundFillColor = [UIColor whiteColor];
    
    p2.drawPoints = YES;
    p2.attributes = @[@"Core", @"Desktop", @"Web", @"DB", @"BI", @"RIA",
                      @"Multimedia", @"Mobile", @"Embedded", @"Integration"];
    p2.maxValue = (_width>_height) ? (_height - 2 * borderSize) / 2 - 70 : (_width - 2 * borderSize) / 2 - 70;
    
    NSArray *b1 = [self pointsToNumericArray];
    p2.dataSeries = @[b1];
    p2.steps = 3;
    p2.backgroundColor = [UIColor whiteColor];
    p2.countLevels = 3;
    p2.koeficient = p2.maxValue / p2.countLevels;
    p2.showStepText = YES;
    [self.view addSubview:p2];
}

- (NSArray *)pointsToNumericArray
{
    NSMutableArray *tempAr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 10; i++)
    {
        NSString *str = _points[i];
        if ([str isEqualToString:@"None"])
            [tempAr addObject: [NSNumber numberWithFloat:0]];
        
        else if ([str isEqualToString:@"Low"])
            [tempAr addObject: [NSNumber numberWithFloat:1]];
        
        else if ([str isEqualToString:@"Middle"])
            [tempAr addObject: [NSNumber numberWithFloat:2]];
        
        else if ([str isEqualToString:@"Strong"])
            [tempAr addObject: [NSNumber numberWithFloat:3]];
        
        else
            [tempAr addObject: [NSNumber numberWithFloat:0]];
    }
    return tempAr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
