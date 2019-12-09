//
//  Runnable.m
//  ProtocolInjection
//
//  Created by 李浩 on 2019/12/9.
//  Copyright © 2019 GodL. All rights reserved.
//

#import "Runnable.h"

@injectprotocol(Runnable)

+ (Class)runClass {
    return self;
}

- (BOOL)canRun {
    return YES;
}

@end
