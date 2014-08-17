//
//  SessionTableViewCell.m
//  APCInfo
//
//  Created by Ben on 16.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "SessionTableViewCell.h"

@implementation SessionTableViewCell

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
