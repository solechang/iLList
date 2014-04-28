//
//  ILLnewTableViewCell.m
//  iLList
//
//  Created by Sebastian Alberini on 4/28/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLnewTableViewCell.h"

@implementation ILLnewTableViewCell

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
- (void) setFrame:(CGRect)frame{
  //  frame.origin.x += 35;
    frame.size.width -= 47;
    [super setFrame:frame];
    
}

@end
