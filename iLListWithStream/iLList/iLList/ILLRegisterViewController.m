//
//  ILLRegisterViewController.m
//  iLList
//
//  Created by Jake Choi on 3/9/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLRegisterViewController.h"
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import "ILLiLListModel.h"

@interface ILLRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation ILLRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //This might change the singleton's model ref to be in users
    //Firebase* childRef = [[ILLiLListModel sharedModel] childByAppendingPath:@"users"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Exiting textfield
- (IBAction)emailTFExit:(id)sender {
    [self.emailTF resignFirstResponder];
    
}
- (IBAction)usernameTFExit:(id)sender {
    [self.usernameTF resignFirstResponder];
}
- (IBAction)passwordTFExit:(id)sender {
    [self.passwordTF resignFirstResponder];
}
- (IBAction)textFieldExitButton:(id)sender {
    [self.emailTF resignFirstResponder];
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}
#pragma Creating id
- (IBAction)createidButton:(id)sender {
    
//    NSLog(@"Email: %@", self.emailTF.text);
    
    // Registering account
    [[ILLiLListModel sharedModel] createUserWithEmail:self.emailTF.text password:self.passwordTF.text andCompletionBlock:^(NSError* error, FAUser* user) {
                                if (error != nil) {
                                    // There was an error creating the account
                                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Your email, username, or password is invalid. Please try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"ok"
                                                      otherButtonTitles:nil] show];

                                } else {
                                    // We created a new user account
//                                    NSLog(@"Account created!");
                                    
                                    [[[UIAlertView alloc] initWithTitle:@"Account Created!"
                                                                message:@"You have successfully created an account! Please login."
                                                               delegate:nil
                                                      cancelButtonTitle:@"ok"
                                                      otherButtonTitles:nil] show];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                            }];
    
}

@end
