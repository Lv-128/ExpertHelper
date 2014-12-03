//
//  CLExternalCell.m
//  Interview Assistant
//
//  Created by nvlizlo on 30.10.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHExternalCell.h"

@implementation EHExternalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
