//
//  IKMediaCell.m
//  InstagramKitDemo
//
//  Created by Shyam Bhat on 01/02/14.
//  Copyright (c) 2014 Shyam Bhat. All rights reserved.
//

#import "IKMediaCell.h"

@implementation IKMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
