//
//  ILLUserViewController.m
//  iLList
//
//  Created by Jake Choi on 4/11/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLUserViewController.h"
#import "ILLiLListModel.h"

@interface ILLUserViewController ()

@end

@implementation ILLUserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOutButton:(id)sender {
   
    [[ILLiLListModel sharedModel] logout];
    [self.tabBarController setSelectedIndex:0];
    
}

@end
