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

- (void)createUserWithEmail:(NSString *)email password:(NSString *)pass andCompletionBlock:(void (^)(NSError *, FAUser *))block {
    [authClient createUserWithEmail:email password:pass andCompletionBlock:block];

    
}
// Same for checkAuthSStatuswWithBlock



//-(void) checkAuthStatusWithBlock:(void (^)(NSError *)error using:(FAUser *)user) {
//    if (error != nil) {
//        // Oh no! There was an error performing the check
//    } else if (user == nil) {
//        // No user is logged in
//        //NSLog(@"Please login");
//        [self performSegueWithIdentifier:@"loginSegue" sender:self];
//    } else {
//        // There is a logged in user
//    }
//}

@end
