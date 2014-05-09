//
//  ILLListOfIllistsViewController.m
//  iLList
//
//  Created by Jake Choi on 4/14/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLSharePlaylistViewController.h"
#import <Firebase/Firebase.h>
#import "ILLiLListModel.h"
#import "ILLPlaylistSongsViewController.h"

@interface ILLSharePlaylistViewController ()

@end

@implementation ILLSharePlaylistViewController

NSString* useridForIllistsView;
NSMutableArray* playlistArray;
NSMutableDictionary *playlistDictionary;


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
    
    [[ILLiLListModel sharedModel] setFlagLogin:NO];
    
    // Although the user illists is listed, it happens to be slow because of race conditions
    // Way around is to store the user's playlists in core data, so that it will displayed quickly
    // rather than waiting for the user's illists to pop from firebase
    
    // playlistArray for the list of names of illists that the user has
    playlistArray = [[NSMutableArray alloc] init];
    playlistDictionary = [[NSMutableDictionary alloc] init];
    
    // Checking if the user exists or is logged in
    [[ILLiLListModel sharedModel] checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            // Oh no! There was an error performing the check
            
        } else if (user == nil) {
            // No user is logged in
            
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            // There is a logged in user
            // Display illists' names the user has
            [[ILLiLListModel sharedModel] setUserID:user.userId];
            useridForIllistsView = user.userId;
            
            //create string to reference user's individual illists
            NSString *linkUsers = @"https://illist.firebaseio.com/users/%@/illists";
            // NSString *linkUserID = [[ILLiLListModel sharedModel] userID];
            
            linkUsers = [NSString stringWithFormat:linkUsers,useridForIllistsView];
            Firebase* userRef = [[Firebase alloc] initWithUrl:linkUsers];
            
            // Retrieving playlist names from firebase when an element is added
            [userRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
                
                // Right when a illist name is added, this is called
                // However the snapshot is empty
                [playlistArray addObject:snapshot];
                [self.tableView reloadData];
                
            }];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    
    // flagLogin checks if user is logged out and this will be ran
    if( [[ILLiLListModel sharedModel] flagLogin] == YES) {
        // Checking if the user exists or is logged in
        [[ILLiLListModel sharedModel] checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
            if (error != nil) {
                // Oh no! There was an error performing the check
                
            } else if (user == nil) {
                // No user is logged in
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            }
        }];
    }
    
    
}
- (IBAction)createIllist:(id)sender {
    // NSLog(@"my storyboard = %@", self.storyboard);
    [self performSegueWithIdentifier:@"createSegue" sender:self];
}
- (IBAction)searchSongs:(id)sender {
    [self performSegueWithIdentifier:@"searchSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return playlistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    FDataSnapshot *playlistSnapshot = playlistArray[indexPath.row];
    
    cell.textLabel.text = playlistSnapshot.value;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    NSString *thisPlaylist = [playlistArray[indexPath.row] name];
    
    
    NSString *pushRefString = [[NSString alloc] initWithFormat:@"https://illist.firebaseio.com/playlists/"];
    pushRefString = [pushRefString stringByAppendingString:thisPlaylist];
    pushRefString = [pushRefString stringByAppendingString:@"/playlistInfo"];
    NSLog(pushRefString);
    Firebase* newPushSongRef = [[Firebase alloc] initWithUrl:pushRefString];
    [newPushSongRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        playlistDictionary = snapshot.value;
        
        NSString *linkUsers = @"https://illist.firebaseio.com/users/";
        NSString *linkUserID = [[ILLiLListModel sharedModel] currentlySelectedFriendID];
        linkUsers = [linkUsers stringByAppendingString:linkUserID];
        linkUsers = [linkUsers stringByAppendingString:@"/illists/"];
        NSLog(linkUsers);
        
        //create reference to user's illists table
        Firebase* userRef = [[Firebase alloc] initWithUrl:linkUsers];
        
        [[userRef childByAppendingPath:[playlistArray[indexPath.row] name]] setValue:playlistDictionary[@"name"]];
        
    }];
    
    NSString *messageStr = [NSString stringWithFormat:@"Succesfully shared iLList!"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alertName" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

    
    if (indexPath) {
        
    }
}

/*
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
