//
//  ProtocolInjection.h
//  ProtocolInjection
//
//  Created by 李浩 on 2019/12/8.
//  Copyright © 2019 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define injectionable \
    + (void)load { \
        pi_classInjected(self); \
    }

#define injection optional;

#define injectprotocol(NAME) \
    interface NAME ## _ProtocolInjectionContainer : NSObject < NAME \
    > {} \
    @end \
    @implementation NAME ## _ProtocolInjectionContainer \
    + (void)load { \
        pi_protocolInjectionAdded(objc_getProtocol((# NAME )),self); \
    }

void pi_protocolInjectionAdded(Protocol *protocol,Class containerClass);

void pi_classInjected(Class injectionClass);

void pi_injection(void);
