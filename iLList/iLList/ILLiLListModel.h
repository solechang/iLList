//
//  ILLiLListModel.h
//  iLList
//
//  Created by Jake Choi on 3/3/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>

@interface ILLiLListModel : NSObject

+(instancetype) sharedModel;

// Creating Firebase user on singleton to check if user is logged in throughout the application
@property (nonatomic, strong) Firebase *ref;
@property (nonatomic, strong) FirebaseSimpleLogin *authClient;


@end
