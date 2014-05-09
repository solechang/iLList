//
//  ILLUserViewController.h
//  iLList
//
//  Created by Jake Choi on 4/11/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILLUserViewController : UIViewController
@property (weak,nonatomic) NSString *songPlaying;
@property (weak, nonatomic) IBOutlet UIWebView *musicPlayerWebView;
@end
