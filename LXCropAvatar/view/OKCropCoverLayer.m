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
@property (nonatomic, strong) CALayer *circleLayer;
@end

@implementation OKCropCoverLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        //方法三：通过layer的border实现
        _circleLayer = [CALayer layer];
        [self insertSublayer:_circleLayer atIndex:0];
    }

    return self;
}

- (void)setOvalInRect:(CGRect)rect {
    if (rect.size.height == 0 || rect.size.width == 0) {
        return;
    }
    _maskRect = rect;
    _circleLayer.frame = rect;
    _circleLayer.cornerRadius = rect.size.width * 0.5;
    _circleLayer.borderColor = [UIColor whiteColor].CGColor;
    _circleLayer.borderWidth = 2;
    _circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self setNeedsDisplay];
}


- (void)drawInContext:(CGContextRef)ctx {
    NSLog(@"ctx:%@====%p",ctx,ctx);
    NSLog(@"CurrentContext:%@====%p",UIGraphicsGetCurrentContext(),UIGraphicsGetCurrentContext());
    //这个方法中是没有当前上下文的，需要把ctx压栈，才有当前的上下文，才能进行UIBezierPath的绘制工作
    //如果不进行压栈要进行绘制就只有直接对绘图上下文ctx进行处理，如：绘制圆的方法二
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

    NSLog(@"ctx:%@-----%p",ctx,ctx);
    NSLog(@"CurrentContext:%@----%p",UIGraphicsGetCurrentContext(),UIGraphicsGetCurrentContext());

    //方法一:绘制的圆形有虚边，通过layer的border实现
//    [[UIColor whiteColor] set];
//    [pickingFieldPath setLineWidth:2];
//    [pickingFieldPath stroke];

    UIGraphicsPopContext();

    //方法二:绘制圆形有虚边
//    CGContextSetLineWidth(ctx, 2.0f);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextStrokeEllipseInRect(ctx, self.maskRect);
//    self.contentsGravity = kCAGravityCenter;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setNeedsDisplay];
}








@end
