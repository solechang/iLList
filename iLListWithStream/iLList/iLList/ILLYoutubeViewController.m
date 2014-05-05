//
//  ILLViewController.m
//  YoutubeSearchDataAPI
//
//  Created by Anthony Merrin on 3/9/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLYoutubeViewController.h"
#import "JSONModelLib.h"
#import "VideoModel.h"
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import "ILLiLListModel.h"

@interface ILLYoutubeViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ILLYoutubeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"Searching for %@",self.searchBar.text);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.webView.hidden = TRUE;
    [self searchYoutubeForTerm:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Youtube Search

- (void)searchYoutubeForTerm:(NSString *)searchTerm
{
    
    self.thisPlaylist = [[ILLiLListModel sharedModel] currentPlaylist];
    
    Firebase* userRef = self.thisPlaylist;
    
    NSString *newSearchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchRequest = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&max-results=50&alt=json", newSearchTerm];
    [JSONHTTPClient getJSONFromURLWithString:searchRequest completion:^(NSDictionary *jsonResponses, JSONModelError *error) {
        NSLog(@"Got JSON from web: %@",jsonResponses);
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
            return;
        }
        self.results = [VideoModel arrayOfModelsFromDictionaries:jsonResponses[@"feed"][@"entry"]];
        if (self.results) NSLog(@"Loaded results into models");
        [self.tableView reloadData];
    }];
    
}

- (void)loadWebViewWithVideo:(VideoModel *)video
{
    /*
    self.webView.hidden = FALSE;
    self.webView.mediaPlaybackRequiresUserAction = YES ;
    VideoLink *link = video.link[0];
    NSLog(@"Video Link: %@",video.link[0]);
    NSString *videoID = nil;
    NSArray *urlToBeConverted = [link.href.query componentsSeparatedByString:@"&"];
    for (NSString *pair in urlToBeConverted) {
        NSArray *pairComponents = [pair componentsSeparatedByString:@"="];
        if([pairComponents[0] isEqualToString:@"v"]) {
            videoID = pairComponents[1];
            break;
        }
    }
    NSLog(@"Embed video id: %@", videoID);
    NSString *htmlString = @"<html><head>\
    <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 320\"/></head>\
    <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
  <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%%0.0f', height:'%%0.0f', videoId:%@, events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script></body></html>";
    
    htmlString = [NSString stringWithFormat:htmlString, videoID];
    
    //this line is to ensure that we can autoplay the youtube video - seb
    
    
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] resourceURL]];
     */
    self.webView.hidden=TRUE;
    self.webView.backgroundColor = [UIColor redColor];
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:self.webView];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"youtube" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *html = [NSMutableString stringWithString:template];
    
    VideoLink *link = video.link[0];
    NSLog(@"Video Link: %@",video.link[0]);
    NSString *videoID = nil;
    NSArray *urlToBeConverted = [link.href.query componentsSeparatedByString:@"&"];
    for (NSString *pair in urlToBeConverted) {
        NSArray *pairComponents = [pair componentsSeparatedByString:@"="];
        if([pairComponents[0] isEqualToString:@"v"]) {
            videoID = pairComponents[1];
            break;
        }
    }
    
    [html replaceOccurrencesOfString:@"[[[video_id]]]" withString:videoID options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://showyou.com"]];
}

#pragma mark - Load Videos into Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    VideoModel *tmp = [self.results objectAtIndex:indexPath.row];
    NSString *tmpString = [[NSString alloc] initWithFormat:@"%@",tmp.title];
    if ([tmpString length] > 29) {
        tmpString = [tmpString substringToIndex:[tmpString length] - ([tmpString length]-27)];
    } else {
        //no characters to delete... attempting to do so will result in a crash
    }
     cell.textLabel.text = tmpString;
    /*
    //Create the button and add it to the cell -added by seb
	UIButton *songTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[songTitleButton setTitle:[NSString stringWithFormat:@"%@",tmp.title]forState:UIControlStateNormal];
    [songTitleButton setTitleColor:[UIColor colorWithRed:0.4 green:0.157 blue:0.024 alpha:1]forState: UIControlStateNormal];
	songTitleButton.frame = CGRectMake(0, 0, 300, 50); //button frame is equal to image size
    
	[cell addSubview:songTitleButton]; //add first button to cell
    */
    //Create the button and add it to the cell -added by seb
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"play-32.png"]; //use play button img
    [button setImage:btnImage forState:UIControlStateNormal];
    [button setTag:indexPath.row];
	[button addTarget:self
			   action:@selector(streamSongFromButton:) //selector for button pressed
	 forControlEvents:UIControlEventTouchDown];
	button.frame = CGRectMake(250, 0, btnImage.size.width, btnImage.size.height); //button frame is equal to image size
    
	[cell addSubview:button]; //add first button to cell
    
    //second button
	UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage2 = [UIImage imageNamed:@"plus-32.png"]; //use plus button img
    [button2 setImage:btnImage2 forState:UIControlStateNormal];
    [button2 setTag:indexPath.row];
	[button2 addTarget:self
                action:@selector(addSongToFirebasePlaylist:) //selector for button pressed
	 forControlEvents:UIControlEventTouchDown];
	button2.frame = CGRectMake(280, 0, btnImage2.size.width, btnImage2.size.height); //button frame is equal to image size
    
	[cell addSubview:button2]; //add second button to cell
    
    
    return cell;
}
-(void) streamSongFromButton: (UIButton *)button {
    NSLog(@"called streamsongFromButton");
    int row =button.tag;
    [self loadWebViewWithVideo:self.results[row]];
}

-(void) addSongToFirebasePlaylist: (UIButton *)button {
    NSLog(@"called addSongTOFireBase");
    //autogenerated playlists id
    int row = button.tag;
    VideoModel * modelToSend = self.results[row];
    
    NSString *pushRefString = [[NSString alloc] initWithFormat:@"https://illist.firebaseio.com/playlists/"];
    pushRefString = [pushRefString stringByAppendingString:self.thisPlaylist.name];
    pushRefString = [pushRefString stringByAppendingString:@"/songs"];
    
    Firebase* newPushSongRef = [[Firebase alloc] initWithUrl:pushRefString];
    
    
//    NSLog(@"%@",newPushSongRef);
//    NSLog(@"%@",modelToSend.title);
    NSString *newTitleToSend = [[ILLiLListModel sharedModel] removeUnknownCharacters:modelToSend.title];
    
    //Create Value of this newCategory
    //NSDictionary *newCategoryValue = @{@"votes":@0,@"youtube link":@([NSDate date].timeIntervalSince1970)};
    
    VideoLink *link = modelToSend.link[0];
    NSString *videoID = nil;
    NSArray *urlToBeConverted = [link.href.query componentsSeparatedByString:@"&"];
    for (NSString *pair in urlToBeConverted) {
        NSArray *pairComponents = [pair componentsSeparatedByString:@"="];
        if([pairComponents[0] isEqualToString:@"v"]) {
            videoID = pairComponents[1];
            break;
        }
    }
    
    NSDictionary *newCategoryValue = @{@"votes":@0,@"link":videoID};

    // Added new playlist (auto generated id)
    [[newPushSongRef childByAppendingPath:newTitleToSend] setValue:newCategoryValue];
    
//    //create string to reference user's individual illists
//    NSString *linkUsers = @"https://illist.firebaseio.com/users/";
//    NSString *linkUserID = [[ILLiLListModel sharedModel] userID];
//    linkUsers = [linkUsers stringByAppendingString:linkUserID];
//    linkUsers = [linkUsers stringByAppendingString:@"/illists/"];
//    linkUsers = [linkUsers stringByAppendingString:self.thisPlaylist.name];
//    linkUsers = [linkUsers stringByAppendingString:@"/"];
//    
//    
//    //create reference to user's illists table
//    Firebase* userRef = [[Firebase alloc] initWithUrl:linkUsers];
//    
//    
//    
//
//    
//    // Added a playlist in user's illist
//    [[userRef childByAppendingPath:newTitleToSend] setValue:videoID];
    
    
    //users.id -> illist -> instead of the auto named id for the playlist, it
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self loadWebViewWithVideo:self.results[indexPath.row]];
}



@end
