//
//  OKCropView.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "OKCropView.h"
#import "CustomScrollView.h"

@interface OKCropView ()<UIScrollViewDelegate>
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, strong) CustomScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
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
        _scrollView = [[CustomScrollView alloc] initWithFrame:self.cropRect];
        [_scrollView addSubview:self.imageView];
        #warning 测试

        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.clipsToBounds = NO;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.delegate = self;



        [self addSubview:_scrollView];


    }

    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.cropRect;
    UIViewController *vc = [self viewController];
    vc.automaticallyAdjustsScrollViewInsets = NO;
}

- (UIViewController *)viewController {
    UIResponder *res = [self nextResponder];
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

    _image = image;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    CGFloat minScale = MAX((self.cropRect.size.width / self.imageView.frame.size.width),(self.cropRect.size.height / self.imageView.frame.size.height));
    _scrollView.minimumZoomScale = minScale;
    _scrollView.maximumZoomScale = 3;
    _scrollView.contentSize = self.imageView.frame.size;
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
    CGRect convertFrame = [self.scrollView convertRect:self.scrollView.bounds toView:self.imageView];
    UIImage *image = [self thumbImageFromImage:_image inRect:convertFrame];
    return image;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


@end
