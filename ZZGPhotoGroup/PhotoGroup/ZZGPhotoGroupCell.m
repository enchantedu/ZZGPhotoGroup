//
//  ZZGPhotoGroupCell.m
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGPhotoGroupCell.h"
#import "ZZGImageView.h"
#import "Masonry.h"
#import "ZZGImageSource.h"
#import "UIButton+ZZGKit.h"

@implementation ZZGPhotoGroupCell {
    ZZGImageView *_imageView;
    UIButton *_deleteButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

+ (NSString *)cellReuseIdentifier {
    return @"LPImageCollectionViewCellReuseIdentifier";
}

- (void)setupViews {
    _imageView = [[ZZGImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didImageViewClick)];
    [_imageView addGestureRecognizer:tap];
        
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.backgroundColor = [UIColor lightGrayColor];
    //todo
//    _deleteButton.layer.masksToBounds = YES;
//    _deleteButton.layer.cornerRadius = 4;
    [_deleteButton setHitEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
    [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(didDeleteImageViewClickAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:_deleteButton];
    
    [self updateConstraints];
}

- (void)updateConstraints {
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_top);
        make.right.equalTo(_imageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [super updateConstraints];
}

#pragma mark - Action
- (void)didImageViewClick {
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (void)didDeleteImageViewClickAtIndexPath:(NSIndexPath *)indexPath {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - Accessor
- (void)setIsLastCollectionCell:(BOOL)isLastCollectionCell {
    _isLastCollectionCell = isLastCollectionCell;
    if (_isLastCollectionCell && !_shouldHideAddButton) {
        _imageView.image = [UIImage imageNamed:@"add"];
        _deleteButton.hidden = YES;
    } else {
        _deleteButton.hidden = NO;
    }
}

- (void)setShouldHideAddButton:(BOOL)shouldHideAddButton {
    _shouldHideAddButton = shouldHideAddButton;
}

- (void)setSourceImage:(ZZGImageSource *)sourceImage {
    _sourceImage = sourceImage;
    if (_sourceImage) {
        if (sourceImage.type == ZZGmageSourceTypeRemote) {
//            [_imageView sd_setImageWithURL:[NSURL URLWithString:sourceImage.sourceURL] placeholderImage:nil];                  
        } else if (sourceImage.type == ZZGImageSourceTypeAlbum) {
            _imageView.image = [UIImage imageWithCGImage:[sourceImage.sourceAsset aspectRatioThumbnail]];
        } else if (sourceImage.type == ZZGImageSourceTypeCamera) {
            _imageView.image = sourceImage.sourceImage;
        }
        
    }
}



@end
