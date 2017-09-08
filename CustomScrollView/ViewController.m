//
//  ViewController.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ViewController.h"
#import "CustomScrollView.h"
#import "SecondViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"测试功能--下一页是封装实现";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:(UIBarButtonItemStylePlain) target:self action:@selector(next:)];

    CGFloat screenWidth =  [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scrollViewWidth = 200;
    CGFloat scrollViewHeight = 200;
    CustomScrollView *scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake((screenWidth - scrollViewWidth) * 0.5, (screenHeight - scrollViewHeight) * 0.5, scrollViewWidth, scrollViewHeight)];

    scrollView.backgroundColor = [UIColor blackColor];
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    _imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    NSLog(@"%f---%f",self.scrollView.center.x,self.scrollView.center.y);
    [scrollView addSubview:self.imageView];
    scrollView.clipsToBounds = NO;
    scrollView.minimumZoomScale = 0.5;
    scrollView.delegate = self;
    scrollView.contentSize = self.imageView.frame.size;

    CGFloat minScale = MAX((scrollViewWidth / self.imageView.frame.size.width),(scrollViewHeight / self.imageView.frame.size.height));
    scrollView.minimumZoomScale = minScale;
    scrollView.maximumZoomScale = 3;
    _scrollView = scrollView;

    [self.view addSubview:scrollView];
    [scrollView setContentOffset:CGPointMake((scrollView.contentSize.width - scrollView.frame.size.width) * 0.5, (scrollView.contentSize.height - scrollView.frame.size.height) * 0.5)];


    _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    [self.view addSubview:_thumbImageView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)next:(id)sender {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (UIImage *)thumbImageFromImage:(UIImage *)image imRect:(CGRect)rect {

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

///**
// * 矫正原图的方向
// */
//- (void)setOriginalImage:(UIImage *)originalImage {
//    if (originalImage) {
//        if (originalImage.imageOrientation != UIImageOrientationUp) {
//            _originalImage = [self imageFromOriginalImage:originalImage];
//        }
//        else {
//            _originalImage = originalImage;
//        }
//    }
//}


- (UIImage *)imageFromOriginalImage:(UIImage *)originalImage {

    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(originalImage.size.width * scale, originalImage.size.height * scale);

    UIGraphicsBeginImageContext(imageSize);

    [originalImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"%s",__func__);
    CGRect convertFrame = [self.scrollView convertRect:self.scrollView.bounds toView:self.imageView];
//    NSLog(@"convertFrame:%@",NSStringFromCGRect(convertFrame));

    UIImage *image = [UIImage imageNamed:@"2.png"];
//    if (CGRectGetMinX(convertFrame) > 0) {

//    }

    _thumbImageView.image = [self thumbImageFromImage:image imRect:convertFrame];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect convertFrame = [self.scrollView convertRect:self.scrollView.bounds toView:self.imageView];
    NSLog(@"convertFrame:%@",NSStringFromCGRect(convertFrame));
    UIImage *image = [UIImage imageNamed:@"2.png"];
//    image = [self imageFromOriginalImage:image];
    _thumbImageView.image = [self thumbImageFromImage:image imRect:convertFrame];
}


- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"2"];
//        image = [self imageFromOriginalImage:image];
        CGFloat screenWidth =  [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = image;
        _imageView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    }

    return _imageView;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    NSLog(@"比例%f",scale);

    CGRect convertFrame = [self.scrollView convertRect:self.scrollView.bounds toView:self.imageView];
//    NSLog(@"convertFrame:%@",NSStringFromCGRect(convertFrame));

    _thumbImageView.image = [self thumbImageFromImage:[UIImage imageNamed:@"2.png"] imRect:convertFrame];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
