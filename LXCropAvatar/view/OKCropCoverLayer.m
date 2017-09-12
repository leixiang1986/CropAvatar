//
//  OKCoverLayer.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/11.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "OKCropCoverLayer.h"

@interface OKCropCoverLayer ()
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) CGRect maskRect;
@property (nonatomic, strong) UIBezierPath *maskPath;
@end

@implementation OKCropCoverLayer

- (instancetype)init {
    self = [super init];
    if (self) {

//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    }

    return self;
}

//+ (instancetype)layer {
//   OKCoverLayer *layer = [super layer];
//    NSLog(@"%s",__func__);
//    return layer;
//}


- (void)setOvalInRect:(CGRect)rect {
    if (rect.size.height == 0 || rect.size.width == 0) {
        return;
    }
    _maskRect = rect;
    [self setNeedsDisplay];
}


    - (void)drawInContext:(CGContextRef)ctx {
        UIGraphicsPushContext(ctx);

        //创建圆形框UIBezierPath:
        UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithOvalInRect:self.maskRect];
        //创建外围大方框UIBezierPath:
        UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:self.bounds];
        //将圆形框path添加到大方框path上去，以便下面用奇偶填充法则进行区域填充：
        [bezierPathRect appendPath:pickingFieldPath];
        [[[UIColor blackColor] colorWithAlphaComponent:0.5] set];
        //填充使用奇偶法则
        bezierPathRect.usesEvenOddFillRule = YES;
        [bezierPathRect fill];

        [[UIColor whiteColor] set];
        [pickingFieldPath setLineWidth:2];
        [pickingFieldPath stroke];
        UIGraphicsPopContext();
        self.contentsGravity = kCAGravityCenter;
    }


//- (void)setup {
//    _maskPath = [UIBezierPath bezierPathWithOvalInRect:_maskRect];
////    [_maskPath moveToPoint:CGPointMake(0, 0)];
////    [_maskPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
////    [_maskPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
////    [_maskPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
////    [_maskPath closePath];
//    _maskLayer = [CAShapeLayer layer];
//    _maskLayer.path = _maskPath.CGPath;
//    _maskLayer.backgroundColor = [UIColor redColor].CGColor;
//    self.mask = _maskLayer;
//
//}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setNeedsDisplay];
}








@end
