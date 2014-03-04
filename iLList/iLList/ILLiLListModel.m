//
//  ILLiLListModel.m
//  iLList
//
//  Created by Jake Choi on 3/3/14.
//  Copyright (c) 2014 iLList. All rights reserved.
//

#import "ILLiLListModel.h"

@implementation ILLiLListModel

// Singleton
+ (instancetype) sharedModel {
    static ILLiLListModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

-(id)init
{
    self = [super init];
    if (self) {
        // Initializing the Firebase account throughout the application
        _ref = [[Firebase alloc] initWithUrl:@"https://illist.firebaseIO-demo.com"];
        _authClient = [[FirebaseSimpleLogin alloc] initWithRef:_ref];
    }
    return self;
}
@end
