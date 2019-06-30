//
//  MFMemoryLeakObject.m
//  ZMFBlogProject
//
//  Created by zmfflying on 2019/6/27.
//  Copyright © 2019 zmfflying. All rights reserved.
//

#import "MFMemoryLeakObject.h"

@implementation MFMemoryLeakObject
+ (MFMemoryLeakObject *)sharedInstance {
    static MFMemoryLeakObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.title = @"1";
    });
    return sharedInstance;
}
@end
