//
//  CLExternalCell.m
//  Interview Assistant
//
//  Created by nvlizlo on 30.10.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHExternalCell.h"

@implementation EHExternalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
    [self.layer setBorderWidth:1.0];
}

@end
