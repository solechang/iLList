//
//  ILLUserViewController.m
//  iLList
//
//  Created by Jake Choi on 4/11/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLUserViewController.h"
#import "ILLiLListModel.h"

@interface ILLUserViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ILLUserViewController
NSString *currentSong;

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentSong = [[NSString alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bannerGradient.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundForTable.png"]]];

	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated{
    if ( ([[ILLiLListModel sharedModel] currentlySelectedSongLink] != nil ) && (currentSong != [[ILLiLListModel sharedModel] currentlySelectedSongLink])){
        currentSong = [[ILLiLListModel sharedModel] currentlySelectedSongLink];
        [self loadWebViewWithVideo:currentSong];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOutButton:(id)sender {
    [[ILLiLListModel sharedModel] setFlagLogin:YES];
    [[ILLiLListModel sharedModel] logout];
    [self.tabBarController setSelectedIndex:0];
}

// Gets the video link and plays the music in the background
- (void)loadWebViewWithVideo:(NSString *)videoLink
{
    self.webView.hidden=FALSE;
    self.webView.backgroundColor = [UIColor blackColor];
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:self.webView];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"youtube" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *html = [NSMutableString stringWithString:template];
    
    
    [html replaceOccurrencesOfString:@"[[[video_id]]]" withString:videoLink options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://showyou.com"]];
}
@end
