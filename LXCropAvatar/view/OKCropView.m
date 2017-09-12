//
//  OKCropView.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "OKCropView.h"
#import "OKExtraHitScrollView.h"
#import "OKCropCoverLayer.h"

@interface OKCropView ()<UIScrollViewDelegate>

@property (nonatomic, strong) OKExtraHitScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) OKCropCoverLayer *coverLayer;      //蒙层
@property (nonatomic, strong) UIImageView *testimageView;
@end

@implementation OKCropView

- (instancetype)initWithFrame:(CGRect)frame cropRect:(CGRect)rect{
    self = [self initWithFrame:frame];
    if (self) {
        if (_cropRect.size.width != 0 && _cropRect.size.height != 0) {
            _cropRect = rect;

        }
    }

    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[OKExtraHitScrollView alloc] initWithFrame:self.cropRect];
        [_scrollView addSubview:self.imageView];

        self.backgroundColor = [UIColor blackColor];
        _scrollView.clipsToBounds = NO;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        self.clipsToBounds = YES;
        [self addSubview:_scrollView];
        [self.layer addSublayer:self.coverLayer];
    }

    return self;
}


- (OKCropCoverLayer *)coverLayer {
    if (!_coverLayer) {
        _coverLayer = [OKCropCoverLayer layer];

    }
    return _coverLayer;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    UIViewController *vc = [self viewControllerForView:newSuperview];
    vc.automaticallyAdjustsScrollViewInsets = NO;
    [super willMoveToSuperview:newSuperview];
}


- (UIImageView *)testimageView {
    if (!_testimageView) {
        _testimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:_testimageView];
    }

    return _testimageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.cropRect;
    _coverLayer.bounds = self.bounds;
    _coverLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    [_coverLayer setOvalInRect:self.cropRect];
    [self.layer insertSublayer:_coverLayer atIndex:(unsigned)(self.layer.sublayers.count - 1)];
}

- (UIViewController *)viewControllerForView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    UIResponder *res = [view nextResponder];
    while (res) {
        if ([res isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)res;
            return vc;
        }
        res = [res nextResponder];
    }
    return nil;
}

- (CGRect)cropRect {
    if (_cropRect.size.width != 0 && _cropRect.size.height != 0) {
        return _cropRect;
    }
    _cropRect.size = CGSizeMake(self.bounds.size.width * 0.6, self.bounds.size.width * 0.6);
    _cropRect.origin = CGPointMake((self.bounds.size.width - _cropRect.size.width) * 0.5, (self.bounds.size.height - _cropRect.size.height) * 0.5);

    return _cropRect;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.cropRect.size.width, self.cropRect.size.height)];
    }

    return _imageView;
}

- (void)setImage:(UIImage *)image {
    if (![image isKindOfClass:[UIImage class]]) {
        return;
    }

    _image = [self adjustImageDirection:image];
    self.imageView.image = _image;
    CGFloat imageScale = _image.size.width / _image.size.height;
    CGFloat cropViewScale = self.bounds.size.width / self.bounds.size.height;
    CGFloat imageViewWidth = self.bounds.size.width;
    CGFloat imageViewHeight = self.bounds.size.height;
    CGFloat zoomScale = 1;
    if (imageScale > cropViewScale) { //图片更宽,imageView的高度设置为cropView的高度,宽度是图片比例算出
        zoomScale = imageViewHeight / _image.size.height;
    }
    else { //图片高度更高,imageView的宽度设置为cropView的宽度,高度通过比例算出

        zoomScale = imageViewWidth / _image.size.width;
    }

    self.imageView.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
    CGFloat minScale = MAX((self.cropRect.size.width / self.imageView.frame.size.width),(self.cropRect.size.height / self.imageView.frame.size.height));

    if (minScale > zoomScale) {
        minScale = zoomScale - 0.5;
    }
    CGFloat maxScale = 3;
    if (maxScale < zoomScale) {
        maxScale = zoomScale + 0.5;
    }
    _scrollView.frame = self.cropRect;
    _scrollView.minimumZoomScale = minScale;
    _scrollView.maximumZoomScale = maxScale;
    _scrollView.contentSize = self.imageView.frame.size;
    _scrollView.zoomScale = zoomScale;
    [_scrollView setContentOffset:CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) * 0.5, (_scrollView.contentSize.height - _scrollView.frame.size.height) * 0.5)];
}

#pragma mark - 矫正图片方向

/**
 * 矫正原图的方向
 */
- (UIImage *)adjustImageDirection:(UIImage *)image {
    if ([image isKindOfClass:[UIImage class]]) {
        if (image.imageOrientation != UIImageOrientationUp) {
            NSLog(@"矫正了方向");
            return [self imageFromOriginalImage:image];
        }
        else {
            NSLog(@"没有矫正方向");
            return image;
        }
    }
    return nil;
}

/**
 * 重新绘制
 */
- (UIImage *)imageFromOriginalImage:(UIImage *)originalImage {
    NSLog(@"开始矫正");
    CGSize imageSize = CGSizeMake(originalImage.size.width , originalImage.size.height);
    UIGraphicsBeginImageContext(imageSize);

    [originalImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"矫正结束");
    return resultImg;
}


- (UIImage *)thumbImageFromImage:(UIImage *)image inRect:(CGRect)rect {

    if (![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    CGImageRelease(subImageRef);
    return smallImage;
}

- (UIImage *)cropedImage {

    //注意这里的转化是scrollView相对于imageView的位置，而imageView是会缩放的,并不是相对于image，而下面的方法需要的Rect是相对于image的frame
    //这里的处理是初始化imageView时zise和image相同，再通过zoomScale做缩放，就能保证转化的frame正确
    CGRect convertFrame = [self convertRect:self.scrollView.frame toView:self.imageView];
    UIImage *image = [self thumbImageFromImage:_image inRect:convertFrame];

    return image;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.imageView;
}


@end
