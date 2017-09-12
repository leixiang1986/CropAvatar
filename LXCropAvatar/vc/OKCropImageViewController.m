//
//  OKCropImageViewController.m
//  OkdeerSeller
//
//  Created by 雷祥 on 2017/9/11.
//  Copyright © 2017年 Okdeer. All rights reserved.
//

#import "OKCropImageViewController.h"
#import "OKCropView.h"
#import "OKCropBottomView.h"
#import "Masonry.h"


static NSInteger kMaxLength = 1024 * 1024; //最大的data长度


@interface OKCropImageViewController ()
@property (nonatomic, strong, readwrite) OKCropView *cropView;
@property (nonatomic, strong, readwrite) OKCropBottomView *bottomView;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat bottomHeight;
@end

@implementation OKCropImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:(UIRectEdgeTop)];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"移动和缩放";
    [self addCropView];
    [self setupBottomView];
}



- (void)addCropView {
    [self.view addSubview:self.cropView];
    _cropView.image = _image;
}

- (CGFloat)viewWidth {
    return self.view.bounds.size.width;
}

- (CGFloat)viewHeight {
    return self.view.bounds.size.height;
}

- (CGFloat)bottomHeight {
    return 60;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}


- (OKCropView *)cropView {
    if (!_cropView) {
        _cropView = [[OKCropView alloc] initWithFrame:CGRectZero];
    }
    _cropView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight - self.bottomHeight);
    return _cropView;
}



/**
 * 设置底部的点击取消或确定的事件
 */
- (void)setupBottomView {
    _bottomView = [[OKCropBottomView alloc] initWithFrame:CGRectZero];
    __weak typeof(self)weakSelf1 = self;
    _bottomView.leftClickBlock = ^{
        __strong typeof(weakSelf1)strongSelf = weakSelf1;
        if (strongSelf.cancelClick) {
            strongSelf.cancelClick(strongSelf);
        }
    };

    __weak typeof(self)weakSelf2 = self;
    _bottomView.rightClickBlock = ^{
        __strong typeof(weakSelf2)strongSelf = weakSelf2;
        if (strongSelf.doneClick) {
            strongSelf.doneClick(strongSelf,[strongSelf.cropView cropedImage]);
        }
    };
    [self.view addSubview:_bottomView];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(self.bottomHeight);
    }];
}

- (void)setImage:(UIImage *)image {
    _image = [self compressImage:image];
    //在已经经过viewDidLoad才从新赋值码，否在用viewDidLoad中的赋值
    if (self.viewLoaded) {
        self.cropView.image = _image;
    }
}

/**
 * 压缩图片
 */
- (UIImage *)compressImage:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    UIImage *compressImage = image;
    if (data.length > kMaxLength) {
        CGFloat scale = kMaxLength * 1.0 / data.length;
        NSData *comressData = UIImageJPEGRepresentation(image, scale);
        compressImage = [UIImage imageWithData:comressData];

    }
    return compressImage;
}



/**
 * 压缩图片
 */
- (void)compressImage:(UIImage *)image complete:(void(^)(UIImage *image))block{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *originImageData = UIImagePNGRepresentation(image);
        UIImage *compressImage = image;
        if (originImageData.length > kMaxLength) {
            CGFloat scale = (kMaxLength * 1.0) / originImageData.length;
            NSData *data = UIImageJPEGRepresentation(_image, scale);
            compressImage = [UIImage imageWithData:data];
        }

        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(compressImage);
            });
        }
    });
}


- (void)dealloc {

}

@end
