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

@interface ILLLoginViewController ()
@property (strong, nonatomic)ILLiLListModel *model;
@end

@implementation ILLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES; // hide navigationitem (back button)
    
    // adding in singleton
    self.model = [ILLiLListModel sharedModel];
    Firebase* authRef = [self.model.ref.root childByAppendingPath:@".info/authenticated"];
    [authRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot* snap) {
        BOOL isAuthenticated = [snap.value boolValue];
        NSLog(@"%@", (isAuthenticated) ? @"True" :@"False");
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
