//
//  CLLinkCell.m
//  Interview Assistant
//
//  Created by nvlizlo on 07.11.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHLinkCell.h"

@implementation EHLinkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image =[UIImage imageNamed:@"stewie"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
