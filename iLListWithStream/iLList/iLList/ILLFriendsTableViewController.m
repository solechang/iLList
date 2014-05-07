//
//  ILLFriendsTableViewController.m
//  iLList
//
//  Created by Jake Choi on 5/5/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLFriendsTableViewController.h"
#import <Firebase/Firebase.h>

@interface ILLFriendsTableViewController () <DNSSwipeableCellDelegate, DNSSwipeableCellDataSource>

@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@property (nonatomic, strong) NSMutableArray *itemTitles;
@property (nonatomic, strong) NSArray *backgroundColors;
@property (nonatomic, strong) NSArray *textColors;
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation ILLFriendsTableViewController

NSArray* friends;
NSMutableArray* matchedFriends;
NSMutableArray* userArray;
static NSString * const ILLFriendsListCellIdentifier = @"Cell";

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
    
    //Register the custom subclass
    [self.tableView registerClass:[ILLFriendsListCell class] forCellReuseIdentifier:ILLFriendsListCellIdentifier];
    
    //Initialize the mutable array so you can add stuff to it.
    _itemTitles = [NSMutableArray array];
    self.cellsCurrentlyEditing = [NSMutableArray array];

    
    userArray = [[NSMutableArray alloc]init];
    matchedFriends  = [[NSMutableArray alloc]init];
    

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
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
    ILLFriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //NSString *textItem = self.itemTitles[indexPath.row];
    //NSString *imageName = self.imageNames[indexPath.row % self.imageNames.count];
    //UIImage *image = [UIImage imageNamed:imageName];
    cell.exampleLabel.text = [matchedFriends[indexPath.row] name];
    //cell.exampleImageView.image = image;
    
   // cell.textLabel.text = [matchedFriends[indexPath.row] name];
    //Set up the buttons
    cell.indexPath = indexPath;
    cell.dataSource = self;
    cell.delegate = self;
    
    [cell setNeedsUpdateConstraints];
    
    //Reopen the cell if it was already editing
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
       [cell openCell:NO];
    }
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    NSString *messageStr = [NSString stringWithFormat:@"whatever"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alertName" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (NSInteger)numberOfButtonsInSwipeableCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        //Even rows have 2 options
        return 2;
    } else {
        //Odd rows 3 options
        return 3;
    }
}
- (NSString *)titleForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return NSLocalizedString(@"Delete", @"Delete");
            break;
        case 1:
            return NSLocalizedString(@"Option 1", @"Option 1");
            break;
        case 2:
            return NSLocalizedString(@"Option 2", @"Option 2");
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index
{
    
    if (index == 0) {
       // [self.cellsCurrentlyEditing removeObject:cell.indexPath];
        [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:cell.indexPath];
    } else {
        [self showDetailForIndexPath:cell.indexPath fromDelegateButtonAtIndex:index];
    }
}
- (UIColor *)backgroundColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return [UIColor redColor];
            break;
        default: {
            return [UIColor colorWithRed:48/255.0f green:190/255.0f blue:5/255.0f alpha:1.0f];
        }
            break;
    }
}
- (UIColor *)textColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return [UIColor colorWithRed:0/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f];
            break;
        default: {
          return [UIColor colorWithRed:0/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f];
        }
            break;
    }
}
- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell
{
    [self.cellsCurrentlyEditing addObject:cell.indexPath];
}
- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:cell.indexPath];
}

- (void)showDetailForIndexPath:(NSIndexPath *)indexPath fromDelegateButtonAtIndex:(NSInteger)buttonIndex
{
    /*
    //Instantiate the DetailVC out of the storyboard.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSString *title = self.itemTitles[indexPath.row];
    if (buttonIndex != -1) {
        NSString *textForCellButton = [self titleForButtonAtIndex:buttonIndex inCellAtIndexPath:indexPath];
        title = [NSString stringWithFormat:@"%@: %@", title, textForCellButton];
    } else {
        title = self.itemTitles[indexPath.row];
    }
    
    detail.detailText = title;
    NSString *imageName = self.imageNames[indexPath.row % self.imageNames.count];
    detail.detailImage = [UIImage imageNamed:imageName];
    
    if (buttonIndex == -1) {
        detail.title = @"Selected!";
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        //Present modally
        detail.title = @"In the delegate!";
        
        //Setup nav controller to contain the detail vc.
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detail];
        
        //Setup button to close the detail VC (will call the method below.
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeModal)];
        [detail.navigationItem setRightBarButtonItem:done];
        [self presentViewController:navController animated:YES completion:nil];
    }
     */
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
