//
//  ILLPlaylistSongsViewController.m
//  iLList
//
//  Created by Jake Choi on 4/25/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLPlaylistSongsViewController.h"
#import "ILLiLListModel.h"

@interface ILLPlaylistSongsViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

NSMutableArray* songArray;
@implementation ILLPlaylistSongsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.myTitle;
    //Create add button for the nav bar - by seb
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"plus-32.png"]; //use play button img
    [button setImage:btnImage forState:UIControlStateNormal];
	[button addTarget:self
			   action:@selector(addButtonPressed) //selector for button pressed
	 forControlEvents:UIControlEventTouchDown];
	button.frame = CGRectMake(250, 0, btnImage.size.width, btnImage.size.height); //button frame is equal to image size
    
    UIBarButtonItem* addBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:addBarButtonItem];
    
  //  [flipButton release];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    songArray = [[NSMutableArray alloc] init];
    self.thisPlaylist = [[ILLiLListModel sharedModel] currentPlaylist];
    NSString *pushRefString = [[NSString alloc] initWithFormat:@"https://illist.firebaseio.com/playlists/"];
    pushRefString = [pushRefString stringByAppendingString:self.thisPlaylist.name];
    pushRefString = [pushRefString stringByAppendingString:@"/songs"];
    NSLog(@"Song href: %@",pushRefString);
    
    Firebase* newPushSongRef = [[Firebase alloc] initWithUrl:pushRefString];
    

    // Retrieving playlist names from firebase when an element is added
    [newPushSongRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        // Right when a illist name is added, this is called
        // However the snapshot is empty
        if(![songArray containsObject:snapshot]) {
            [songArray addObject:snapshot];
        }
        
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) addButtonPressed{
//    NSLog(@"my storyboard = %@", self.storyboard);
    [self performSegueWithIdentifier:@"addASong" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return songArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    FDataSnapshot *playlistSnapshot = songArray[indexPath.row];
    
    cell.textLabel.text = playlistSnapshot.name;
    
    NSDictionary *songDictionary = playlistSnapshot.value;
    NSString *voteCount = [NSString stringWithFormat:@"Likes: %@",songDictionary[@"votes"]];

    cell.detailTextLabel.text = voteCount;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDataSnapshot *playlistSnapshot = songArray[indexPath.row];
    NSDictionary *songDictionary = playlistSnapshot.value;
//    NSLog(@"%@",songDictionary[@"link"]);
    [self loadWebViewWithVideo:songDictionary[@"link"]];
}
// Gets the video link and plays the music in the background
- (void)loadWebViewWithVideo:(NSString *)videoLink
{
    
    self.webView.hidden=TRUE;
    self.webView.backgroundColor = [UIColor redColor];
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:self.webView];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"youtube" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *html = [NSMutableString stringWithString:template];
    
    
    [html replaceOccurrencesOfString:@"[[[video_id]]]" withString:videoLink options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://showyou.com"]];
}


/*
-(void) addSongToFirebasePlaylist: NSString *songName
{
    
    //autogenerated playlists id
    Firebase* newPushSongRef = self.thisPlaylist;
    
    //Create Value of this newCategory
    NSDictionary *newCategoryValue = @{@"votes":@0,@"youtube link":@([NSDate date].timeIntervalSince1970)};
    
    // Added new playlist (auto generated id)
    [[newPushSongRef childByAppendingPath:songName] setValue:newCategoryValue];
    
    //create string to reference user's individual illists
    NSString *linkUsers = @"https://illist.firebaseio.com/users/";
    NSString *linkUserID = [[ILLiLListModel sharedModel] userID];
    linkUsers = [linkUsers stringByAppendingString:linkUserID];
    linkUsers = [linkUsers stringByAppendingString:@"/illists/"];
    
    //create reference to user's illists table
    Firebase* userRef = [[Firebase alloc] initWithUrl:linkUsers];
    
    // Added a playlist in user's illist
    [[userRef childByAppendingPath:newPushSongRef.name] setValue:songName];
    
    
     //users.id -> illist -> instead of the auto named id for the playlist, it
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
