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
@property (strong, nonatomic)ILLiLListModel *model;
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
    self.model.ref = [[Firebase alloc] initWithUrl:@"https://illist.firebaseIO-demo.com/users"];
    
    self.model.authClient = [[FirebaseSimpleLogin alloc] initWithRef:self.model.ref];
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
    
    [self.model.authClient createUserWithEmail:self.emailTF.text password:self.passwordTF.text
                            andCompletionBlock:^(NSError* error, FAUser* user) {
                                
                                if (error != nil) {
                                    // There was an error creating the account
                                    NSLog(@"4.)");
                                } else {
                                    // We created a new user account
                                    NSLog(@"Account created!");
                                }
                            }];
    
}

@end
