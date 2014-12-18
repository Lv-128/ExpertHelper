//
//  EHLegendView.h
//  EHRadarChart
//
//  Created by EH on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHLegendView : UIView

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *colors;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EH_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithAttributes : @{ NSFontAttributeName : font }] : CGSizeZero;
#define EH_DRAW_TEXT_AT_POINT(text, point, font) [text drawAtPoint : point withAttributes : @{ NSFontAttributeName:font }];
#define EH_DRAW_TEXT_IN_RECT(text, rect, font) [text drawInRect : rect withAttributes : @{ NSFontAttributeName:font }];
#else
#define EH_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithFont : font] : CGSizeZero;
#define EH_DRAW_TEXT_AT_POINT(text, point, font) [text drawAtPoint : point withFont : font];
#define EH_DRAW_TEXT_IN_RECT(text, rect, font) [text drawInRect : rect withFont : font];

#endif

@end
