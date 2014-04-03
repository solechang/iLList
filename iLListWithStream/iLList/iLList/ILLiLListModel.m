//
//  ILLiLListModel.m
//  iLList
//
//  Created by Jake Choi on 3/3/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLiLListModel.h"

@implementation ILLiLListModel

Firebase *ref;
FirebaseSimpleLogin *authClient;

// Singleton
+ (instancetype) sharedModel {
    static ILLiLListModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initializing the Firebase account throughout the application
        ref = [[Firebase alloc] initWithUrl:@"https://illist.firebaseIO-demo.com"];
        authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    }
    return self;
}

// Create user with email
- (void)createUserWithEmail:(NSString *)email password:(NSString *)pass andCompletionBlock:(void (^)(NSError *, FAUser *))block {
    
    [authClient createUserWithEmail:email password:pass andCompletionBlock:block];
}

// checking if user is logged in
- (void) checkAuthStatusWithBlock:(void (^)(NSError *, FAUser *))block  {
    [authClient checkAuthStatusWithBlock:block];
}

- (void) logInToFacebookWithAppWithID: (NSString *)appId permissions:(NSString *)email
                             audience:ACFacebookAudienceOnlyMe withCompletionBlock:(void (^)(NSError *, FAUser *))block {
    
    
    [authClient loginToFacebookAppWithId:appId permissions:nil
                                audience:ACFacebookAudienceOnlyMe
                     withCompletionBlock:block];


}


@end
