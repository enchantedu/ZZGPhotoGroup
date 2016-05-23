# ZZGPhotoGroup
A photo selecter like sending weibo, user can move the sequeue of the image arbitrarily.

How to use in a UITableView?

    _imageGroupView = [[ZZGPhotoGroupView alloc] init];
    _imageGroupView.currentViewController = self;
    _imageGroupView.tag = 999;
    __weak UITableView *weakTableView = _tableView;
    _imageGroupView.loadHeightBlock = ^(CGFloat height){
        _collectionViewHeight = height;
        NSLog(@"-------------%s-----%f",__func__, height);
        [weakTableView  reloadData];
    };
    
    the imageGropu can return the height of imageGorup use the loadHeigthBlock;
