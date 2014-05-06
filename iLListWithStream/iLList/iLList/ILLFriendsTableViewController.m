//
//  ILLFriendsTableViewController.m
//  iLList
//
//  Created by Jake Choi on 5/5/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLFriendsTableViewController.h"
#import <Firebase/Firebase.h>

@interface ILLFriendsTableViewController ()

@end

@implementation ILLFriendsTableViewController
NSArray* friends;
NSMutableArray* matchedFriends;
NSMutableArray* userArray;

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
    
    userArray = [[NSMutableArray alloc]init];
    matchedFriends  = [[NSMutableArray alloc]init];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // This function is to check through Facebook SDK and seeing which
    // Friends are using iLList
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              //run your user info request here
                                              FBRequest* friendsRequest = [FBRequest requestForMyFriends];
                                              [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                                                            NSDictionary* result,
                                                                                            NSError *error) {
                                                  
                                                  if (error) {
                                                      NSLog(@"1.) %@", error);
                                                  }
                                                  
                                                  
                                                  
                                                  friends = [result objectForKey:@"data"];
                                                  
                                                  
                                                  NSString *pushRefString = [[NSString alloc] initWithFormat:@"https://illist.firebaseio.com/users"];
                                                  
                                                  Firebase* newPushSongRef = [[Firebase alloc] initWithUrl:pushRefString];
                                                  
                                                  
                                                  // Retrieving playlist names from firebase when an element is added
                                                  [newPushSongRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
                                                      
                                                      // Right when a illist name is added, this is called
                                                      // However the snapshot is empty
                                                      [userArray addObject:snapshot];
                                                      
                                                      for (NSObject *friend in friends){
                                                          if ([[friend valueForKey:@"id"] isEqual: snapshot.name]){
                                                              // Friends that do have iLList are added into matchedFriends array
                                                              [matchedFriends addObject:friend];
                                                              [self.tableView reloadData];
                                                          }
                                                      }
                                                  }];

                                              }];
                                          }
                                      }];
    }
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
    return matchedFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [matchedFriends[indexPath.row] name];
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
