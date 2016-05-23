//
//  UIButton+ZZGKit.m
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/23.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "UIButton+ZZGKit.h"
#import <objc/runtime.h>

static char HitTestEdgeInsets;

@implementation UIButton (ZZGKit)

- (void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets {
    NSValue *value = [NSValue value:&hitEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &HitTestEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &HitTestEdgeInsets);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
