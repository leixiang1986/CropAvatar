//
//  OKCropView.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "OKCropView.h"

@interface OKCropView ()
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation OKCropView

- (instancetype)initWithFrame:(CGRect)frame cropRect:(CGRect)rect{
    self = [super initWithFrame:frame];
    if (self) {
        if (_cropRect.size.width != 0 && _cropRect.size.height != 0) {
            _cropRect = rect;
        }
        _scrollView = [[UIScrollView alloc] initWithFrame:self.cropRect];
    }

    return self;
}


- (CGRect)cropRect {
    if (_cropRect.size.width != 0 && _cropRect.size.height != 0) {
        return _cropRect;
    }
    _cropRect.size = CGSizeMake(self.bounds.size.width * 0.6, self.bounds.size.width * 0.6);
    _cropRect.origin = self.center;
    return _cropRect;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }

    return _imageView;
}

- (void)setImage:(UIImage *)image {
    if (![image isKindOfClass:[UIImage class]]) {
        return;
    }

    _image = image;
    self.imageView.image = image;
//    self.imageView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)


}


- (UIImage *)cropedImage {

    return nil;
}

@end
