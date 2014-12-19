//
//  EHRadarChart.h
//  EHRadarChart
//
//  Created by EH on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHRadarChart : UIView

@property (nonatomic, assign) CGFloat r;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) BOOL drawPoints; 
@property (nonatomic, assign) BOOL fillArea;
@property (nonatomic, assign) BOOL showLegend;
@property (nonatomic, assign) BOOL showStepText;
@property (nonatomic, assign) CGFloat colorOpacity;
@property (nonatomic, strong) UIColor *backgroundLineColorRadial;
@property (nonatomic, strong) NSArray *dataSeries;
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, assign) NSUInteger steps;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, strong) UIColor *backgroundFillColor;

@property (nonatomic, assign) NSInteger koeficient;
@property (nonatomic, assign) NSInteger countLevels;

- (void)setTitles:(NSArray *)titles;
- (void)setColors:(NSArray *)colors;

@end
