//
//  ILLListOfIllistsViewController.m
//  iLList
//
//  Created by Jake Choi on 4/14/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLListOfIllistsViewController.h"
#import <Firebase/Firebase.h>
#import "ILLiLListModel.h"

@interface ILLListOfIllistsViewController ()

@property (nonatomic, assign) int myInt;
@end

@implementation ILLListOfIllistsViewController

NSString* useridForIllistsView;


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


}

- (void) viewWillAppear:(BOOL)animated {
   
    // Although the user illists is listed, it happens to be slow because of race conditions
    // Way around is to store the user's playlists in core data, so that it will displayed quickly
    // rather than waiting for the user's illists to pop from firebase
    [[ILLiLListModel sharedModel] checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            // Oh no! There was an error performing the check
            
        } else if (user == nil) {
            // No user is logged in
            
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            // There is a logged in user
            [[ILLiLListModel sharedModel] setUserID:user.userId];
            useridForIllistsView = user.userId;

            //create string to reference user's individual illists
            NSString *linkUsers = @"https://illist.firebaseio.com/users/";
            NSString *linkUserID = [[ILLiLListModel sharedModel] userID];

            linkUsers = [linkUsers stringByAppendingString:useridForIllistsView];

            //create reference to user's illists table
            NSString* playlistsRefURL = [[NSString alloc] initWithFormat:@"https://illist.firebaseio.com/playlists/"];
            Firebase* userRef = [[Firebase alloc] initWithUrl:linkUsers];
            
//            [userRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//                NSLog(@"%@", snapshot.value);
//                
//            }];
            [userRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                
                NSLog(@"%@", snapshot.value);
            }];
            
        }
    }];
    
}
- (IBAction)createIllist:(id)sender {
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
    
    // SET THIS********$$$$$$$$$$
    // THis may be a problem when loading user's playlists
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"illistNames" forIndexPath:indexPath];
    
    __block NSMutableArray *playlists;
    
    //create string to reference user's individual illists
    NSString *linkUsers = @"https://illist.firebaseio.com/users/";
    NSString *linkUserID = [[ILLiLListModel sharedModel] userID];

    linkUsers = [linkUsers stringByAppendingString:linkUserID];

    //create reference to user's illists table
    NSString* playlistsRefURL = [[NSString alloc] initWithFormat:@"https://illist.firebaseio.com/playlists/"];
    Firebase* userRef = [[Firebase alloc] initWithUrl:linkUsers];
    
    [userRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *userData = snapshot.value;
        playlists = userData[@"illist"];
        NSString *tmpName = [playlists objectAtIndex:indexPath.row];
        [playlistsRefURL stringByAppendingString:tmpName];
        Firebase* playlistsRef = [[Firebase alloc] initWithUrl:playlistsRefURL];
//        cell.textLabel.text = @"HI!";


    }];
    
    return cell;
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
