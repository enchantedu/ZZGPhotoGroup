//
//  ZZGImageSource.h
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSUInteger, ZZGImageSourceType) {
    ZZGmageSourceTypeRemote,
    ZZGImageSourceTypeAlbum,
    ZZGImageSourceTypeCamera
};

@interface ZZGImageSource : NSObject

//Source Type
@property (nonatomic, assign) ZZGImageSourceType type;

// Remote
@property (nonatomic, copy) NSString *sourceURL;

// Album
//@property (nonatomic, strong) ALAsset *sourceAsset;
@property (nonatomic, strong) ALAsset *sourceAsset;


// Camera
@property (nonatomic, strong) UIImage *sourceImage;

// Qiniu Key
@property (nonatomic, copy) NSString *qiniuKey;


- (instancetype)initWithType:(ZZGImageSourceType)type;

@end






























