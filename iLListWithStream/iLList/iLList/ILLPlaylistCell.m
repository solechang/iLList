//
//  ILLPlaylistCell.m
//  iLList
//
//  Created by Sebastian Alberini on 5/6/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLPlaylistCell.h"

@implementation ILLPlaylistCell

- (void)commonInit
{
    [super commonInit];
    
    //Setup the pieces of this cell which will be reused
    
    //USE THIS CODE TO ADD AN IMAGE TO playlist CELL!!- SEB
    
    // CGFloat imageHeight = kExampleCellHeight - (kBetweenViewsMargin * 2);
    //self.exampleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kExampleCellLeftMargin, kBetweenViewsMargin, //imageHeight, imageHeight)];
    //    [self.myContentView addSubview:self.exampleImageView];
    
    //  CGFloat labelXOrigin = CGRectGetMaxX(self.exampleImageView.frame) + kBetweenViewsMargin;
    // CGFloat labelWidth = CGRectGetWidth(self.frame) - labelXOrigin - kExampleCellRightMargin;
    
    
    self.songNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 230, 50)];
    self.songNameLabel.numberOfLines = 0;
    [self.myContentView addSubview:self.songNameLabel];
    
    self.likesImage = [UIImage imageNamed:@"like-32.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.likesImage];
    imageView.frame = CGRectMake(240, 10, self.likesImage.size.width, self.likesImage.size.height);
    [self.myContentView addSubview:imageView];
    
    self.likesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 50, 50)];
    self.likesCountLabel.numberOfLines = 0;
    [self.myContentView addSubview:self.likesCountLabel];
    
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
