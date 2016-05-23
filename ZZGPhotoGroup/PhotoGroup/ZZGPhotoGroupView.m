//
//  ZZGPhotoGroupView.m
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGPhotoGroupView.h"
#import "MWPhotoBrowser.h"
#import <CTAssetsPickerController.h>
#import "Masonry.h"
#import "ZZGPhotoGroupLayout.h"
#import "ZZGPhotoGroupCell.h"
#import "ZZGImageSource.h"
#import <UIImageView+WebCache.h>
#import "UICollectionView+Move.h"

NSString *const kZZGPhotoGroupViewAddedNotification = @"kZZGPhotoGroupViewAddedNotification";
NSString *const kZZGPhotoGroupViewUploadedNotification = @"kZZGPhotoGroupViewUploadedNotification";
NSString *const kZZGPhotoGroupViewRemovedNotification = @"kZZGPhotoGroupViewRemovedNotification";

static char ZZGPhotoGroupViewImageSource;

static CGFloat const kImageGroupEdgeSpacing = 10;
static NSInteger const kImagesDefaultColumnCount = 4;
static CGFloat const kImageDefaultItemSpacing = 60;
static CGFloat const kImageDefaultItemSize = 68;

@interface ZZGPhotoGroupView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, CTAssetsPickerControllerDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageSources;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZZGPhotoGroupView {
    ZZGPhotoGroupLayout *_layout;
    
    UIButton *_addButton;
    MWPhotoBrowser *_browser;
    
    CGFloat _groupViewHeight;
}


#pragma mark - UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefault];
        [self setupViews];
    }
    return self;
}

- (void)setupDefault {
    _imageSources = [NSMutableArray new];
    _limitCount = 9;
    
    _itemSize = kImageDefaultItemSize;
    _itemSpacing = kImageGroupEdgeSpacing;
    _sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
}

- (void)setupViews {
    _layout = [[ZZGPhotoGroupLayout alloc] init];
    _layout.itemSize = CGSizeMake(_itemSize, _itemSize);
    _layout.itemSpacing = _itemSpacing;
    _layout.sectionInset = _sectionInset;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ZZGPhotoGroupCell class] forCellWithReuseIdentifier:[ZZGPhotoGroupCell cellReuseIdentifier]];
    [self addSubview:_collectionView];
    
//    __weak ZZGPhotoGroupView *weakSelf = self;
    [_collectionView addLongPressMoveCellWithActionHandler:^{
        NSLog(@"long press end");
//        [weakSelf.collectionView reloadData];
    }];
    _collectionView.tempDataSource = self.imageSources;
    
    [self updateConstraints];
}

- (void)updateConstraints {
    
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    
}

#pragma makr - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (_imageSources.count >= self.limitCount) ? self.limitCount : (_imageSources.count + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _imageSources.count && indexPath.row <= self.limitCount) {
        ZZGPhotoGroupCell *lastImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZZGPhotoGroupCell cellReuseIdentifier] forIndexPath:indexPath];
        lastImageCell.isLastCollectionCell = YES;
        lastImageCell.completionBlock = ^(){
            NSLog(@"----------------add button click");
            if (_imageSources.count >= _limitCount) {
//                lastImageCell.shouldHideAddButton = YES;
                return;
            }
            [self didAddPhotoButtonClick];
        };
        return lastImageCell;
    } else {
        ZZGPhotoGroupCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZZGPhotoGroupCell cellReuseIdentifier] forIndexPath:indexPath];
        imageCell.sourceImage = _imageSources[indexPath.row];
        imageCell.isLastCollectionCell = NO;
        imageCell.completionBlock = ^(){
            _browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            //            _browser.enableDeleteAction = YES;
            _browser.displayActionButton = !self.disableDeleteButton;
            [_browser setCurrentPhotoIndex:indexPath.row];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:_browser];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.currentViewController presentViewController:nc animated:YES completion:nil];
        };
        imageCell.deleteBlock = ^(){
            [_imageSources removeObjectAtIndex:indexPath.row];
            [_collectionView reloadData];
        };
        
        return imageCell;
    }

}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadHeightBlock && (_groupViewHeight != collectionView.contentSize.height)) {
        _groupViewHeight = collectionView.contentSize.height;
        self.loadHeightBlock(_groupViewHeight);
    }
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - Action
- (void)didAddPhotoButtonClick {
    if (self.imageGroupPhotoSourceType == ZZGPhotoGroupViewSourceTypeBrowser) {
        CTAssetsPickerController *assetPicker = [[CTAssetsPickerController alloc] init];
        assetPicker.assetsFilter = [ALAssetsFilter allAssets];
        assetPicker.showsCancelButton = YES;
        assetPicker.delegate = self;
        [self.currentViewController presentViewController:assetPicker animated:YES completion:nil];

    } else if (self.imageGroupPhotoSourceType == ZZGPhotoGroupViewSourceTypeSingle) {
        
    }
}


#pragma mark - CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *arrayM = [NSMutableArray new];
    [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
        ZZGImageSource *imageSource = [[ZZGImageSource alloc] initWithType:ZZGImageSourceTypeAlbum];
        imageSource.sourceAsset = asset;
        [arrayM addObject:imageSource];
    }];
    [_imageSources addObjectsFromArray:arrayM];
    
    [_collectionView reloadData];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageSources.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    ZZGImageSource *source = [_imageSources objectAtIndex:index];
    
    if (source.type == ZZGmageSourceTypeRemote) {
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:source.sourceURL]];
        return photo;
    } else if (source.type == ZZGImageSourceTypeAlbum) {
        ALAssetRepresentation *assetRep = [source.sourceAsset defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *image = [UIImage imageWithCGImage:imgRef scale:1 orientation:(UIImageOrientation)assetRep.orientation];
        
        MWPhoto *photo = [[MWPhoto alloc] initWithImage:image];
        return photo;
    } else {
        MWPhoto *photo = [[MWPhoto alloc] initWithImage:source.sourceImage];
        return photo;
    }
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%lu/%lu", index+1, _imageSources.count];
}


- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset {
    if (self.limitCount <= 0)
        return YES;
    
    NSInteger leftCount = self.limitCount - _imageSources.count;
    if (picker.selectedAssets.count >= leftCount) {
        return NO;
    }
    return YES;
}


#pragma mark - Public Method
- (void)uploadImageOnSuccess:(LPImageGroupCollectionViewVoidBlock) successBlock onFail:(LPImageGroupCollectionViewVoidBlock) failBlock {
    NSLog(@"-------------------upload---------");
    
}


@end

































































