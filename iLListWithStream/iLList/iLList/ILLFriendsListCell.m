//
//  ILLFriendsListCell.m
//  iLList
//
//  Created by Sebastian Alberini on 5/6/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLFriendsListCell.h"

@implementation ILLFriendsListCell



- (void)commonInit
{
    [super commonInit];
    
    //Setup the pieces of this cell which will be reused
    
    //USE THIS CODE TO ADD AN IMAGE TO FRIEND's LIST CELL!!- SEB
    
   // CGFloat imageHeight = kExampleCellHeight - (kBetweenViewsMargin * 2);
    //self.exampleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kExampleCellLeftMargin, kBetweenViewsMargin, //imageHeight, imageHeight)];
//    [self.myContentView addSubview:self.exampleImageView];
    
  //  CGFloat labelXOrigin = CGRectGetMaxX(self.exampleImageView.frame) + kBetweenViewsMargin;
   // CGFloat labelWidth = CGRectGetWidth(self.frame) - labelXOrigin - kExampleCellRightMargin;
   
    
    self.friendNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 200, 50)];
    self.friendNameLabel.numberOfLines = 0;
    [self.myContentView addSubview:self.friendNameLabel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
