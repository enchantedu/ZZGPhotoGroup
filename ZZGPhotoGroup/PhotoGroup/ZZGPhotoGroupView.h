//
//  ZZGPhotoGroupView.h
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kZZGPhotoGroupViewAddedNotification;
extern NSString *const kZZGPhotoGroupViewUploadedNotification;
extern NSString *const kZZGPhotoGroupViewRemovedNotification;

typedef NS_ENUM(NSInteger, ZZGPhotoGroupViewSourceType) {
    ZZGPhotoGroupViewSourceTypeBrowser,/**<照片库多选*/
    ZZGPhotoGroupViewSourceTypeSingle,/**<照片库单选*/
};

typedef void(^LPImageGroupCollectionViewVoidBlock)();
typedef void(^LPImageGroupCollectionViewCGFloatBlock)(CGFloat height);

@interface ZZGPhotoGroupView : UIView

@property (nonatomic, assign)ZZGPhotoGroupViewSourceType imageGroupPhotoSourceType;/**<照片库,默认多选*/

@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat itemSize;
@property (nonatomic) UIEdgeInsets sectionInset;

@property (nonatomic, assign) NSInteger limitCount; //group里的照片最大数

@property (nonatomic, assign) BOOL showAddButton;
@property (nonatomic, assign) BOOL disableDeleteButton;

//Must set the current view controller
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, assign) BOOL isPresentModal;

//Image
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UIImage *addButtonImage;
@property (nonatomic, strong) UIImage *deleteImage;

//Qiniu
@property (nonatomic, assign) BOOL autoUploadQiniu;
@property (nonatomic, copy) NSString *qiniuUploadToken;
@property (nonatomic, copy) NSString *qiniuUploadPrefix;

//Photos
@property (nonatomic, strong) NSArray *photosUrl;


@property (nonatomic, copy) LPImageGroupCollectionViewCGFloatBlock loadHeightBlock;

- (void)uploadImageOnSuccess:(LPImageGroupCollectionViewVoidBlock) successBlock onFail:(LPImageGroupCollectionViewVoidBlock) failBlock;

@end
































