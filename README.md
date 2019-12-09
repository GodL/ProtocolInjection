ProtocolInjection
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/GodL/ProtocolInjection/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/ProtocolInjection.svg?style=flat)](http://cocoapods.org/pods/ProtocolInjection)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;


Default implementation of protocol optional methods

Usage
==============
Create protocol
```objc

@protocol Runnable <NSObject>

@injection

+ (Class)runClass;

- (BOOL)canRun;

@end

```

Realize the methods
```objc
@injectprotocol(Runnable)

+ (Class)runClass {
    return self;
}

- (BOOL)canRun {
    return YES;
}

@end
```

Confirm this protocol
```
@interface ViewController ()<Runnable>

@end
```

Realize injection in .m
```
@implementation ViewController (Injection)

injectionable

@end

```

Result 
```
ProtocolInjection[10762:501490] 1   ViewController
```


Installation
==============

### CocoaPods

1. Add `pod 'ProtocolInjection'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<ProtocolInjection/ProtocolInjection.h\>.

Requirements
==============
This library requires `iOS 6.0+` and `Xcode 8.0+`.

License
==============
ProtocolInjection is provided under the MIT license. See LICENSE file for details.
