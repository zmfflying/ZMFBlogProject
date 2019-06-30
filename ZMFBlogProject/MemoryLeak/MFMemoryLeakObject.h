//
//  MFMemoryLeakObject.h
//  ZMFBlogProject
//
//  Created by zmfflying on 2019/6/27.
//  Copyright © 2019 zmfflying. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFMemoryLeakObject : NSObject

@property (nonatomic, copy) NSString *title;

+ (MFMemoryLeakObject *)sharedInstance;
@end

NS_ASSUME_NONNULL_END
