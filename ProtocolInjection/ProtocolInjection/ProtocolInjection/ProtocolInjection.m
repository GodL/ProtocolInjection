//
//  ProtocolInjection.m
//  ProtocolInjection
//
//  Created by 李浩 on 2019/12/8.
//  Copyright © 2019 GodL. All rights reserved.
//

#import "ProtocolInjection.h"
@import ObjectiveC.message;
#import <CoreFoundation/CoreFoundation.h>
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
        unsigned long size = 0;
    #ifndef __LP64__
        uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, "Injection", &size);
    #else
        const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
        uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, "Injection", &size);
    #endif
        unsigned long counter = size/sizeof(void*);
        for(int idx = 0; idx < counter; ++idx){
            char *string = (char*)memory[idx];
            NSString *str = [NSString stringWithUTF8String:string];
            if(!str) continue;
            pi_classInjected(NSClassFromString(str));
        }
}

__attribute__((constructor(500))) static void __init() {
    _dyld_register_func_for_add_image(dyld_callback);
}

__attribute__((constructor(501))) static void ProtocolInject (void) {
    pi_injection();
}

static CFMutableDictionaryRef restrict injectionProtocols = NULL;

static CFMutableSetRef restrict injectionClasses = NULL;

FOUNDATION_STATIC_INLINE void _injectMethod(Class class,Method method) {
    if (class_getInstanceMethod(class, method_getName(method))) {
        printf("Errr: Class has a custom imp for thie method %s %s",sel_getName(method_getName(method)),class_getName(class));
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
        if (CFDictionaryContainsKey(injectionProtocols, (__bridge const void *)([NSString stringWithUTF8String:protocol_getName(protocol)]))) {
            Class containerClass = CFDictionaryGetValue(injectionProtocols, (__bridge const void *)([NSString stringWithUTF8String:protocol_getName(protocol)]));
            unsigned int count = 0;
            Method *instanceMethods = class_copyMethodList(containerClass, &count);
            for (unsigned int j=0; j<count; j++) {
                _injectMethod(class, instanceMethods[j]);
            }
            Method *classMethods = class_copyMethodList(object_getClass(containerClass), &count);
            for (unsigned int j=0; j<count; j++) {
                _injectMethod(object_getClass(class), classMethods[j]);
            }
            free(instanceMethods);
            free(classMethods);
        }
    }
    free(protocols);
}

void pi_protocolInjectionAdded(Protocol *protocol,Class containerClass) {
    NSCParameterAssert(protocol);
    NSCParameterAssert(containerClass);
    if (injectionProtocols == NULL) {
        injectionProtocols = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    
    if (CFDictionaryContainsKey(injectionProtocols, (__bridge const void *)([NSString stringWithUTF8String:protocol_getName(protocol)]))) {
        printf("Error: Could not inejct an already injected protocol");
        return;
    }
    
    CFDictionarySetValue(injectionProtocols, (__bridge const void *)([NSString stringWithUTF8String:protocol_getName(protocol)]), (__bridge const void *)(containerClass));
}

void pi_classInjected(Class injectionClass) {
    NSCParameterAssert(injectionClass);
    if (injectionClasses == NULL) {
        injectionClasses = CFSetCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeSetCallBacks);
    }
    if (CFSetContainsValue(injectionClasses, (__bridge const void *)(injectionClass))) {
        printf("Eooro: Could not inject an already injected class");
        return;
    }
    CFSetSetValue(injectionClasses, (__bridge const void *)(injectionClass));
}

void pi_injection(void) {
    if (injectionClasses == NULL) {
        printf("There is nothing to inject");
        return;
    }
    CFSetApplyFunction(injectionClasses, (CFSetApplierFunction)&InjectionClassApplierFunction, NULL);
    CFRelease(injectionClasses);
    CFRelease(injectionProtocols);
    injectionClasses = NULL;
    injectionProtocols = NULL;
    
}
