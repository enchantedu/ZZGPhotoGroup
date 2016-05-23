//
//  UICollectionView+Move.m
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/22.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "UICollectionView+Move.h"
#import <objc/runtime.h>

static char collectionViewTempDataSource;
static char collectionViewSelectedIndexPath;
static char collectionViewRawIndexPath;
static char collectionViewTempView;
static char collectionViewActionHandler;

@implementation UICollectionView (Move)

@dynamic tempDataSource, selectedIndexPath, tempView, actionHandler, rawIndexPath;

- (void)addLongPressMoveCellWithActionHandler:(void (^)(void))actionHandler {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressCollection:)];
    [self addGestureRecognizer:longPress];
   
    self.actionHandler = actionHandler;
}

#pragma mark - UILongPressGestureRecognizer
- (void)didLongPressCollection:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self longPressGestureBegain:longPress];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self longPressGestureChanged:longPress];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self longPressGestureEnd:longPress];           
        }
            break;
            
        default:
            break;
    }
}


- (void)longPressGestureBegain:(UILongPressGestureRecognizer *)longPressGesture {
    CGPoint point = [longPressGesture locationInView:longPressGesture.view];
    NSIndexPath *selectedIndexPath = [self indexPathForItemAtPoint:point];
    if (!selectedIndexPath)
        return;
    
    self.selectedIndexPath = selectedIndexPath;
    self.rawIndexPath = selectedIndexPath;
    
    NSUInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
    if (self.tempDataSource.count < numberOfItems && self.rawIndexPath.row == numberOfItems - 1)
        return;
    
    UICollectionViewCell *selectedCell = [self cellForItemAtIndexPath:selectedIndexPath];
    self.tempView = [self snapshotViewWithInputView:selectedCell];
    
//    NSLog(@"tempDataSource --begain:%@",self.tempDataSource);
    
    //todo custom style
    self.tempView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.tempView.layer.masksToBounds = NO;
    self.tempView.layer.cornerRadius = 0;
    self.tempView.layer.shadowOffset = CGSizeMake(-5, 0);
    self.tempView.layer.shadowOpacity = 0.4;
    self.tempView.layer.shadowRadius = 5;
    self.tempView.alpha = 0.8;
    
    self.tempView.frame = selectedCell.frame;
    [self addSubview:self.tempView];
    selectedCell.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tempView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    }];

}

- (void)longPressGestureChanged:(UILongPressGestureRecognizer *)longPressGesture {
    CGPoint point = [longPressGesture locationInView:longPressGesture.view];
    NSUInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
    
    NSIndexPath *currentIndexPath = [self indexPathForItemAtPoint:point];

    if (self.tempDataSource.count < numberOfItems && self.rawIndexPath.row == numberOfItems - 1)
        return;
    
    if (self.tempDataSource.count < numberOfItems && currentIndexPath.row == numberOfItems - 1 && ![self.selectedIndexPath isEqual:currentIndexPath]) {
        currentIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row - 1 inSection:0];
    }
    
    if (currentIndexPath && ![self.selectedIndexPath isEqual:currentIndexPath] && ((self.tempDataSource.count < numberOfItems && currentIndexPath.row != numberOfItems - 1) || self.tempDataSource.count == numberOfItems)) {
        [self updateCellFromIndexPath:self.selectedIndexPath toIndexPath:currentIndexPath];
        self.selectedIndexPath = currentIndexPath;
    }
    
    self.tempView.center = CGPointMake(point.x, point.y);
}

- (void)longPressGestureEnd:(UILongPressGestureRecognizer *)longPressGesture {
    CGPoint point = [longPressGesture locationInView:longPressGesture.view];
    
    NSUInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
    UICollectionViewCell *selectedCell = [self cellForItemAtIndexPath:self.selectedIndexPath];
    
    NSIndexPath *currentIndexPath = [self indexPathForItemAtPoint:point];

    if (self.tempDataSource.count < numberOfItems && self.rawIndexPath.row == numberOfItems - 1)
        return;
    
    if (self.tempDataSource.count < numberOfItems && currentIndexPath.row == numberOfItems - 1 && ![self.selectedIndexPath isEqual:currentIndexPath]) {
        currentIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row - 1 inSection:0];
    }
    
    NSInteger rawRow = self.rawIndexPath.row;
    NSInteger currentRow = currentIndexPath.row;
    
    if (currentIndexPath && ![self.rawIndexPath isEqual:currentIndexPath] && ((self.tempDataSource.count < numberOfItems && currentIndexPath.row != numberOfItems - 1) || self.tempDataSource.count == numberOfItems)) {
        if (rawRow > currentRow) {
            for (NSInteger i = rawRow - currentRow; i > 0; i --) {
                [self.tempDataSource exchangeObjectAtIndex:(currentRow + i) withObjectAtIndex:(currentRow + i - 1)];
            }
        } else {
            for (NSInteger i = 0; i < currentRow - rawRow; i ++) {
                [self.tempDataSource exchangeObjectAtIndex:(rawRow + i) withObjectAtIndex:(rawRow + i + 1)];
            }
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tempView.frame = selectedCell.frame;
    } completion:^(BOOL finished) {
        selectedCell.hidden = NO;
        if (self.actionHandler)
            self.actionHandler();
            
        [self.tempView removeFromSuperview];
    }];
    
//    NSLog(@"tempDataSource --end:%@",self.tempDataSource);
}

#pragma mark - Accessor

- (NSMutableArray *)tempDataSource {
    return objc_getAssociatedObject(self, &collectionViewTempDataSource);
}

- (void)setTempDataSource:(NSMutableArray *)tempDataSource {
    [self willChangeValueForKey:@"collectionViewTempDataSource"];
    objc_setAssociatedObject(self, &collectionViewTempDataSource,
                             tempDataSource,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"collectionViewTempDataSource"];
}

- (NSIndexPath *)selectedIndexPath {
    return objc_getAssociatedObject(self, &collectionViewSelectedIndexPath);
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    objc_setAssociatedObject(self, &collectionViewSelectedIndexPath,
                             selectedIndexPath,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (NSIndexPath *)rawIndexPath {
    return objc_getAssociatedObject(self, &collectionViewRawIndexPath);
}

- (void)setRawIndexPath:(NSIndexPath *)rawIndexPath {
    objc_setAssociatedObject(self, &collectionViewRawIndexPath,
                             rawIndexPath,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)tempView {
    return objc_getAssociatedObject(self, &collectionViewTempView);
}

- (void)setTempView:(UIView *)tempView {
    objc_setAssociatedObject(self, &collectionViewTempView,
                             tempView,
                             OBJC_ASSOCIATION_RETAIN);
}

- (UICollectionViewMoveCompleteBlock)actionHandler {
    return objc_getAssociatedObject(self, &collectionViewActionHandler);
}

- (void)setActionHandler:(UICollectionViewMoveCompleteBlock)actionHandler {
    objc_setAssociatedObject(self, &collectionViewActionHandler,
                             actionHandler,
                             OBJC_ASSOCIATION_COPY);
}

#pragma mark Private action

- (UIView *)snapshotViewWithInputView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}

- (void)updateCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}



@end
