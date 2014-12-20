//
//  EHRecorderCommaentCell.m
//  ExpertHelper
//
//  Created by Katolyk S. on 12/8/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHRecorderCommaentCell.h"

@implementation EHRecorderCommaentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    _button = [EHPlayPause buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = CGRectMake(self.frame.size.width - (self.frame.size.height + 5), self.frame.origin.y, self.frame.size.height, self.frame.size.height);
    self.accessoryView = _button;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
