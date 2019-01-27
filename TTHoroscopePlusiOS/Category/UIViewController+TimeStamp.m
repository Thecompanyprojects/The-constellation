//
//  UIViewController+TimeStamp.m
//  Horoscope
//
//  Created by KevinXu on 2018/9/29.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "UIViewController+TimeStamp.h"
#import <objc/runtime.h>


static const char kTimeDurationKey;
static const char kExitTimeStampKey;
static const char kEnterTimeStampKey;
static const char kTagStringKey;

@implementation UIViewController (TimeStamp)

- (NSString *)kTimeDuration {
    return objc_getAssociatedObject(self, &kTimeDurationKey);
}

- (NSString *)kEnterTimeStamp {
    return objc_getAssociatedObject(self, &kEnterTimeStampKey);
}

- (NSString *)kExitTimeStamp {
    return objc_getAssociatedObject(self, &kExitTimeStampKey);
}

- (NSString *)kTagString {
    return objc_getAssociatedObject(self, &kTagStringKey);
}

- (void)setKTimeDuration:(NSString *)kTimeDuration {
    objc_setAssociatedObject(self, &kTimeDurationKey, kTimeDuration, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setKExitTimeStamp:(NSString *)kExitTimeStamp {
    objc_setAssociatedObject(self, &kExitTimeStampKey, kExitTimeStamp, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setKEnterTimeStamp:(NSString *)kEnterTimeStamp {
    objc_setAssociatedObject(self, &kEnterTimeStampKey, kEnterTimeStamp, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setKTagString:(NSString *)kTagString {
    objc_setAssociatedObject(self, &kTagStringKey, kTagString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
