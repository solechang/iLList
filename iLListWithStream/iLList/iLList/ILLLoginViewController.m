//
//  ILLLoginViewController.m
//  iLList
//
//  Created by Jake Choi on 2/28/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLLoginViewController.h"
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import "ILLiLListModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ILLYoutubeViewController.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface ILLLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *faceBookLoginButton;

@end

@implementation ILLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES; // hide navigationitem (back button)

    // adding in singleton
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)passWordExitTF:(id)sender {
    [self.passWordTF resignFirstResponder];
    
}
- (IBAction)loginPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)newUserButton:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:self];
}
- (IBAction)fbLoginButton:(id)sender {
    
    [self.faceBookLoginButton setEnabled:NO];
    __block NSString *useridInLogin;
    [[ILLiLListModel sharedModel] logInToFacebookWithAppWithID:@"211472342396196"
                                                   permissions:nil
                                                      audience:ACFacebookAudienceOnlyMe withCompletionBlock:^(NSError *error, FAUser *user){
        if (error != nil) {
            // There was an error logging in
            NSLog(@"%@", error);
        } else {
            
            NSString *linkUsers = @"https://illist.firebaseio.com/users/";
            linkUsers = [linkUsers stringByAppendingString:user.userId];
            
            Firebase* existsRef = [[Firebase alloc] initWithUrl:linkUsers];
            
            [existsRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                if(snapshot.value == [NSNull null]) {

                    // We have a logged in facebook user
                    Firebase* userRef = [[Firebase alloc] initWithUrl:@"https://illist.firebaseio.com/users"];
                    
                    [[userRef childByAppendingPath:user.userId]  setValue:@""];
                    
                    userRef = [[Firebase alloc] initWithUrl:linkUsers];
                    [[userRef childByAppendingPath:@"user_id" ] setValue:user.userId];

                    useridInLogin = user.userId;
                    
                    // Saving the userID for the program
                    [[ILLiLListModel sharedModel] setUserID:useridInLogin];
                    NSLog(@"%@", [[ILLiLListModel sharedModel] userID]);
                    

                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    NSLog(@" 6.) User julie exists");
                    [[ILLiLListModel sharedModel] setFlagLogin:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        
        }// else
    }];
    

    [self performSelector:@selector(turnOffTime:) withObject:nil afterDelay:1.5];
  
}



// Facebook login button delay
- (void)turnOffTime:(NSTimer*)timer {
    [self.faceBookLoginButton setEnabled:YES];

}


#pragma Auto Scrolling when clicked on Username/password textfield
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.userNameTF] || [sender isEqual:self.passWordTF])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


@end
