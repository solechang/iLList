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
    self.webView.hidden = FALSE;
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
    <iframe id=\"ytplayer\" type=\"text/html\" width=\"320\" height=\"240\"\
    src=\"http://www.youtube.com/embed/%@?autoplay=1\"\
    frameborder=\"0\"/>\
    </body></html>";
    
    htmlString = [NSString stringWithFormat:htmlString, videoID, videoID];
    
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];
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
    cell.textLabel.text = tmp.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self loadWebViewWithVideo:self.results[indexPath.row]];
}

@end
