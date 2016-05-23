//
//  ViewController.m
//  ZZGPhotoGroup
//
//  Created by dito on 16/5/21.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ViewController.h"
#import "ZZGPhotoGroupView.h"
#import "Masonry.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController {
    UITableView *_tableView;
    ZZGPhotoGroupView *_imageGroupView;
    CGFloat _collectionViewHeight;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _imageGroupView = [[ZZGPhotoGroupView alloc] init];
    _imageGroupView.currentViewController = self;
    _imageGroupView.tag = 999;
    __weak UITableView *weakTableView = _tableView;
    _imageGroupView.loadHeightBlock = ^(CGFloat height){
        _collectionViewHeight = height;
        NSLog(@"-------------%s-----%f",__func__, height);
        [weakTableView  reloadData];
    };
    
    [self updateViewConstraints];

}

- (void)updateViewConstraints {
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return (_collectionViewHeight < 92) ? 92 : _collectionViewHeight;
    } else {
        return 80;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        UITableViewCell *imageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        [imageCell.contentView addSubview:_imageGroupView];
        [_imageGroupView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(imageCell.contentView);
        }];
        return imageCell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"labelCell"];
        cell.textLabel.text = @"imageGroup";
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_imageGroupView uploadImageOnSuccess:^{
        NSLog(@"-----------------upload image success");
    } onFail:^{
        NSLog(@"------------------upload image fail");
    }];
}

@end















































