//
//  AssetView.m
//  YTWY_Client
//
//  Created by Mr.S on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AssetView.h"
#import <Photos/Photos.h>
#define Item_Size  CGSizeMake((My_ScreenW - 50)/4, (My_ScreenW-50)/4*1.3)

@interface AssetView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property void (^onComplete)(UIImage* image);
@property UIViewController* vc;

@property UICollectionView* collectionView;

@property PHFetchResult *assetsFetchResults;
@property PHCachingImageManager *imageManager;

@property NSMutableArray<UIImage *>* photoArr;

@end

@implementation AssetView

+(AssetView *)showInVC:(UIViewController *)vc onComplete:(void (^)(UIImage* image))onComplete
{
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [[self shareView].photoArr removeAllObjects];
    [self shareView].vc = vc;
    [self shareView].onComplete = onComplete;
    [[self shareView] showInController:[self shareView].vc preferredStyle:TYAlertControllerStyleActionSheet];
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
    
    return [self shareView];
}

+ (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                [[self shareView].photoArr addObject:result];
                [[self shareView].collectionView reloadData];
                if (asset == assets.lastObject) {
                    [SVProgressHUD dismiss];
                }
                NSLog(@"%ld,%ld",[self shareView].photoArr.count,[self shareView].assetsFetchResults.count);
            }
            
        }];
    }
}

+(AssetView *)shareView
{
    static AssetView* view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[AssetView alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, My_ScreenH/2)];
    });
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor lightGrayColor];
        self.imageManager = [[PHCachingImageManager alloc] init];
        self.photoArr = [[NSMutableArray alloc]init];
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = self.backgroundColor;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView* imv = nil;
    for (UIView* subView in cell.contentView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            imv = (UIImageView *) subView;
            break;
        }
    }
    if (!imv) {
        imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height)];
        imv.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    imv.image = self.photoArr[indexPath.row];
    [cell.contentView addSubview:imv];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return Item_Size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
