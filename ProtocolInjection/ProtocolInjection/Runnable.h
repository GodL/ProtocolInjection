//
//  Runnable.h
//  ProtocolInjection
//
//  Created by 李浩 on 2019/12/9.
//  Copyright © 2019 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolInjection.h"

NS_ASSUME_NONNULL_BEGIN

@protocol Runnable <NSObject>

@optional
+ (Class)runClass;

- (BOOL)canRun;

@property (nonatomic,copy) NSString *name;

@end

@protocol Singable <Runnable>

@optional
- (BOOL)canSing;

@end

NS_ASSUME_NONNULL_END
