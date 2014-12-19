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
    
    
    borderSize = 50;
    
	p2 = [[EHRadarChart alloc] initWithFrame:CGRectMake(borderSize, borderSize, _size - borderSize*2 , _size - borderSize*2)];
	p2.centerPoint = CGPointMake((_size - 2*borderSize)/2, (_size - 2*borderSize)/2);
	p2.showLegend = YES;
    p2.backgroundFillColor = [UIColor whiteColor];
    
	[p2 setTitles:@[@"a"]];//, @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"]];
	p2.drawPoints = YES;
	p2.attributes = @[@"Core", @"Desktop", @"Web", @"DB", @"BI", @"RIA",
	                  @"Multimedia", @"Mobile", @"Embedded", @"Integration"];
    
    
	NSArray *b1 = [self pointsToNumericArray];
    //	NSArray *b2 = @[@(91), @(87), @(43), @(77), @(78), @(96), @(51), @(65), @(77), @(55)];
    //	NSArray *b3 = @[@(51), @(97), @(87), @(60), @(25), @(77), @(93), @(14), @(53), @(34)];
    //	NSArray *b4 = @[@(11), @(87), @(65), @(77), @(55), @(84), @(43), @(77), @(78), @(96)];
    //	NSArray *b5 = @[@(41), @(97), @(87), @(60), @(95), @(77), @(73), @(74), @(59), @(82)];
    //	NSArray *b6 = @[@(61), @(96), @(51), @(65), @(77), @(87), @(43), @(70), @(78), @(55)];
    //	NSArray *b7 = @[@(81), @(97), @(74), @(53), @(82), @(65), @(87), @(60), @(85), @(77)];
    //	NSArray *b8 = @[@(91), @(84), @(43), @(67), @(78), @(96), @(47), @(55), @(67), @(55)];
    //	NSArray *b9 = @[@(38), @(85), @(77), @(93), @(74), @(53), @(82), @(97), @(87), @(60)];
    //	NSArray *b10 = @[@(31), @(87), @(43), @(37), @(78), @(96), @(51), @(65), @(17), @(55)];
	p2.dataSeries = @[b1];//, b2, b3, b4, b5, b6, b7, b8, b9, b10];
	p2.steps = 1;
	p2.backgroundColor = [UIColor whiteColor];
    p2.countLevels = 4;
    p2.koeficient = p2.maxValue/p2.countLevels;
	[self.view addSubview:p2];
}
- (NSArray *)pointsToNumericArray{
    NSMutableArray * tempAr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i <10; i++)
    {
        NSString *str = _points[i];
        if ([str isEqualToString:@"None"])
        {
            [tempAr addObject: [NSNumber numberWithFloat:1]];
        }
        else if ([str isEqualToString:@"Low"])
        {
            [tempAr addObject: [NSNumber numberWithFloat:2]];
        }
        else if ([str isEqualToString:@"Middle"])
        {
            [tempAr addObject: [NSNumber numberWithFloat:3]];
        }
        else if ([str isEqualToString:@"Strong"])
        {
            [tempAr addObject: [NSNumber numberWithFloat:4]];
        }
        else   [tempAr addObject: [NSNumber numberWithFloat:0]];
        
    }
    return tempAr;
    
}
- (void)updateData {
	int n = 7;
	NSMutableArray *a = [NSMutableArray array];
	NSMutableArray *b = [NSMutableArray array];
	NSMutableArray *c = [NSMutableArray array];
    
    
	for (int i = 0; i < n - 1; i++) {
		a[i] = [NSNumber numberWithInt:arc4random() % 40 + 80];
		b[i] = [NSNumber numberWithInt:arc4random() % 50 + 70];
		c[i] = [NSNumber numberWithInt:arc4random() % 60 + 60];
	}
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
