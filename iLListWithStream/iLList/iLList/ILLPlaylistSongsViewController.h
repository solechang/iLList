//
//  ILLPlaylistSongsViewController.h
//  iLList
//
//  Created by Jake Choi on 4/25/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "VideoModel.h"
#import "ILLPlaylistCell.h"
#import "ILLFriendsListCell.h"
#import "ILLUserViewController.h"

@interface ILLPlaylistSongsViewController : UITableViewController
@property (nonatomic) NSString* myTitle;

@property(weak,nonatomic) NSString *songName;
@property(weak, nonatomic) Firebase *thisPlaylist;
@end
