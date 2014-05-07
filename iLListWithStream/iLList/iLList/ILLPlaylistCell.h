//
//  ILLPlaylistCell.h
//  iLList
//
//  Created by Sebastian Alberini on 5/6/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "DNSSwipeableCell.h"

@interface ILLPlaylistCell : DNSSwipeableCell

//image to be taken from facebook pic
@property (nonatomic, strong) UIImageView *exampleImageView;
//optional label for cell
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UIImage *likesImage;
@property (nonatomic, strong) UILabel *likesCountLabel;

@end
