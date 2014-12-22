//
//  EHRadarChart.h
//  EHRadarChart
//
//  Created by EH on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EH_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithAttributes : @{ NSFontAttributeName : font }] : CGSizeZero;
#define EH_DRAW_TEXT_AT_POINT(text, point, font) [text drawAtPoint : point withAttributes : @{ NSFontAttributeName:font }];
#define EH_DRAW_TEXT_IN_RECT(text, rect, font) [text drawInRect : rect withAttributes : @{ NSFontAttributeName:font }];

#define COLOR_PADDING 15

#define FONT_SIZE 14

#define CIRCLE_DIAMETER 5

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
@property (nonatomic, copy) NSArray *colors;


- (void)setColors:(NSArray *)colors;

@end
