//
//  ZZGImageSource.m
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGImageSource.h"

@implementation ZZGImageSource

- (instancetype)initWithType:(ZZGImageSourceType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

@end
