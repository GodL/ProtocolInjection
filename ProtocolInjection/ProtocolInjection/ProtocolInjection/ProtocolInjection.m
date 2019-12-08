//
//  ProtocolInjection.m
//  ProtocolInjection
//
//  Created by 李浩 on 2019/12/8.
//  Copyright © 2019 GodL. All rights reserved.
//

#import "ProtocolInjection.h"
@import ObjectiveC.runtime;
@import ObjectiveC.message;
#import <CoreFoundation/CoreFoundation.h>

static CFMutableDictionaryRef restrict injectionProtocols = NULL;

static CFMutableSetRef restrict injectionClasses = NULL;

FOUNDATION_STATIC_INLINE void _injectMethod(Class class,Method method) {
    if (class_getInstanceMethod(class, method_getName(method))) {
        printf("Errr: Class has a custom imp for thie method %s",sel_getName(method_getName(method)));
        return;
    }
    class_addMethod(class, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

static void InjectionClassApplierFunction(const void *value,const void *context) {
    Class class = (__bridge Class)(value);
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(class, &count);
    for (unsigned int i =0; i<count; i++) {
        Protocol *protocol = protocols[i];
        if (CFDictionaryContainsKey(injectionProtocols, protocol_getName(protocol))) {
            Class containerClass = CFDictionaryGetValue(injectionProtocols, protocol_getName(protocol));
            unsigned int count = 0;
            Method *instanceMethods = class_copyMethodList(containerClass, &count);
            for (unsigned int j=0; j<count; j++) {
                _injectMethod(class, instanceMethods[j]);
            }
            Method *classMethods = class_copyMethodList(object_getClass(containerClass), &count);
            for (unsigned int j=0; j<count; j++) {
                _injectMethod(object_getClass(containerClass), classMethods[j]);
            }
            free(instanceMethods);
            free(classMethods);
        }
    }
    free(protocols);
}

void protocolInjectionAdded(Protocol *protocol,Class containerClass) {
    NSCParameterAssert(protocol);
    NSCParameterAssert(containerClass);
    if (injectionProtocols == NULL) {
        injectionProtocols = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFCopyStringDictionaryKeyCallBacks, NULL);
    }
    
    if (CFDictionaryContainsKey(injectionProtocols, protocol_getName(protocol))) {
        printf("Error: Could not inejct an already injected protocol");
        return;
    }
    
    CFDictionaryAddValue(injectionProtocols,protocol_getName(protocol), (__bridge const void *)(containerClass));
    
}

void classInjected(Class injectionClass) {
    NSCParameterAssert(injectionClass);
    if (!injectionClasses) {
        injectionClasses = CFSetCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeSetCallBacks);
    }
    if (CFSetContainsValue(injectionClasses, (__bridge const void *)(injectionClass))) {
        printf("Eooro: Could not inject an already injected class");
        return;
    }
    CFSetAddValue(injectionClasses, (__bridge const void *)(injectionClass));
}

void injection(void) {
    CFSetApplyFunction(injectionClasses, (CFSetApplierFunction)&InjectionClassApplierFunction, NULL);
    CFRelease(injectionClasses);
    CFRelease(injectionProtocols);
    injectionClasses = NULL;
    injectionProtocols = NULL;
    
}
