//
//  ILLViewController.h
//  YoutubeSearchDataAPI
//
//  Created by Anthony Merrin on 3/9/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ILLYoutubeViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate>

@property(weak,nonatomic) NSString *songName;
@property(weak, nonatomic) Firebase *thisPlaylist;
@end
