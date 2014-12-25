//
//  EHRadarChart.m
//  EHRadarChart
//
//  Created by EH on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "EHRadarChart.h"
#import "EHAppDelegate.h"


#define PADDING 75
#define ATTRIBUTE_TEXT_SIZE_IPAD 17
#define ATTRIBUTE_TEXT_SIZE_IPHONE 15
#define SCALE_TEXT_SIZE 12
#define COLOR_HUE_STEP 5
#define MAX_NUM_OF_COLOR 17

@interface EHRadarChart ()

@property (nonatomic, assign) NSUInteger numOfV;
@property (nonatomic, strong) UIFont *scaleFont;
@property (nonatomic, strong) UIFont *scaleLevelsFont;

@end

@implementation EHRadarChart

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        [self setDefaultValues];
	}
	return self;
}


- (void)setDefaultValues {
    self.backgroundColor = [UIColor whiteColor];
    _centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _r = MIN(self.frame.size.width / 2 - PADDING, self.frame.size.height / 2 - PADDING);
    _steps = 1;
    _drawPoints = NO;
    _showLegend = NO;
    _showStepText = NO;
    _fillArea = NO;
    
    _colorOpacity = 1.0;
    _backgroundLineColorRadial = [UIColor darkGrayColor];
    _backgroundFillColor = [UIColor whiteColor];
    
    
    _colors = [[NSArray alloc]init];
    _attributes = @[@"you", @"should", @"set", @"these", @"data", @"titles,",
                    @"this", @"is", @"just", @"a", @"placeholder"];
    _countLevels = 3;
    _koeficient = _maxValue / _countLevels;
    _minValue = _koeficient;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        _scaleFont = [UIFont systemFontOfSize:ATTRIBUTE_TEXT_SIZE_IPAD];
    else
        _scaleFont = [UIFont systemFontOfSize:ATTRIBUTE_TEXT_SIZE_IPHONE];
    
    _scaleLevelsFont = [UIFont systemFontOfSize:SCALE_TEXT_SIZE];
    
}

- (void)setColors:(NSArray *)colors {
    NSMutableArray *array = [_colors mutableCopy];
    [array removeAllObjects];
    for (UIColor *color in colors) {
        [array addObject:[color colorWithAlphaComponent:self.colorOpacity]];
    }
    _colors = array;
}


- (void)setDataSeries:(NSArray *)dataSeries {
	_dataSeries = dataSeries;
	_numOfV = [_dataSeries[0] count];
    NSMutableArray *array = [self.colors mutableCopy];
	if (self.colors.count < _dataSeries.count) {
		for (int i = 0; i < _dataSeries.count; i++) {
			UIColor *color = [UIColor colorWithHue:1.0 * (i * COLOR_HUE_STEP % MAX_NUM_OF_COLOR) / MAX_NUM_OF_COLOR
			                            saturation:1
			                            brightness:1
			                                 alpha:self.colorOpacity];
			array[i] = color;
		}
	}
    self.colors = array;
}


- (void)drawRect:(CGRect)rect {
	NSArray *colors = [self.colors copy];
	CGFloat radPerV = M_PI * 2 / _numOfV;
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	//draw attribute text
	CGFloat height = [self.scaleFont lineHeight];
	CGFloat padding = 2.0;
	for (int i = 0; i < _numOfV; i++) {
		NSString *attributeName = _attributes[i];
		CGPoint pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
        
		CGSize attributeTextSize = EH_TEXT_SIZE(attributeName, self.scaleFont);
		NSInteger width = attributeTextSize.width;
        
		CGFloat xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
		CGFloat yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
		CGPoint legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset);
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineBreakMode:NSLineBreakByClipping];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attributes = @{ NSFontAttributeName: self.scaleFont,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        [attributeName drawInRect:CGRectMake(legendCenter.x - width / 2.0,
                                             legendCenter.y - height / 2.0,
                                             width,
                                             height)
                   withAttributes:attributes];
        
    }
    
    
    //draw background fill color
    [_backgroundFillColor setFill];
    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r);
    for (int i = 1; i <= _numOfV; ++i) {
        CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
                                _centerPoint.y - _r * cos(i * radPerV));
    }
    CGContextFillPath(context);
    
	//draw steps line
	static CGFloat dashedPattern[] = {4,4};
	//TODO: make this color a variable
	[[UIColor lightGrayColor] setStroke];
	CGContextSaveGState(context);
	for (int step = 1; step <= _steps; step++) {
		for (int i = 0; i <= _numOfV; ++i) {
			if (i == 0) {
				CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r * step / _steps);
			}
			else {
                CGContextSetLineDash(context, 0, dashedPattern, 2);
				CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV) * step / _steps,
				                        _centerPoint.y - _r * cos(i * radPerV) * step / _steps);
			}
		}
		CGContextStrokePath(context);
	}
	CGContextRestoreGState(context);
    
	//draw lines from center
	[_backgroundLineColorRadial setStroke];
	for (int i = 0; i < _numOfV; i++) {
		CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
		CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
		                        _centerPoint.y - _r * cos(i * radPerV));
		CGContextStrokePath(context);
	}
	//end of base except axis label
    
    
	CGContextSetLineWidth(context, 2.0);
    
	//draw lines
	for (int serie = 0; serie < [_dataSeries count]; serie++) {
		if (self.fillArea) {
			[colors[serie] setFill];
		}
		else {
			[colors[serie] setStroke];
		}
		for (int i = 0; i < _numOfV; ++i) {
			CGFloat value = [_dataSeries[serie][i] floatValue]*_koeficient;
			if (i == 0) {
				CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
			}
			else {
				CGContextAddLineToPoint(context, _centerPoint.x - (value - _minValue) / (_maxValue  - _minValue) * _r * sin(i * radPerV),
				                        _centerPoint.y - (value - _minValue ) / (_maxValue  - _minValue) * _r * cos(i * radPerV));
			}
		}
		CGFloat value = [_dataSeries[serie][0] floatValue]*_koeficient;
        
		CGContextAddLineToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
        
		if (self.fillArea) {
			CGContextFillPath(context);
		}
		else {
			CGContextStrokePath(context);
		}
        
        
		//draw data points
		if (_drawPoints) {
			for (int i = 0; i < _numOfV; i++) {
				CGFloat value = [_dataSeries[serie][i] floatValue]*_koeficient;
				CGFloat xVal = _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV);
				CGFloat yVal = _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV);
                
				[colors[serie] setFill];
				CGContextFillEllipseInRect(context, CGRectMake(xVal - 4, yVal - 4, 8, 8));
				[self.backgroundColor setFill];
				CGContextFillEllipseInRect(context, CGRectMake(xVal - 2, yVal - 2, 4, 4));
			}
		}
	}
    
	if (self.showStepText) {
		//draw step label text, alone y axis
		//TODO: make this color a variable
		[[UIColor blackColor] setFill];
		for (int step = 1; step <= _steps; step++) {
			//CGFloat value = _minValue + (_maxValue - _minValue) * step / _steps;
			//NSString *currentLabel = [NSString stringWithFormat:@"%.0f", value];
            NSString *currentLabel = [NSString stringWithFormat:@"%@", ESTIMATES[step-1]];
            
			EH_DRAW_TEXT_IN_RECT(currentLabel,
			                     CGRectMake(_centerPoint.x + 3,
			                                _centerPoint.y - _r * step / _steps - 3,
			                                50,
			                                15),
			                     self.scaleLevelsFont);
		}
	}
}

@end
