//
//  OKCustomScrollView.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "OKCustomScrollView.h"

@interface OKCustomScrollView (){
    BOOL _setContentSized; //是否设置过contentSize，如果设置过，在重新赋值frame时就不替换，如果没有设置，contentSize为frame.size
}
@property (nonatomic, assign) CGPoint startLocation;

@end

@implementation OKCustomScrollView
@synthesize contentSize = _contentSize;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:gesture];
    }

    return self;
}


- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
    _setContentSized = YES;
}


- (CGSize)contentSize {
    if (_setContentSized) {

        _contentSize.width = _contentSize.width < self.bounds.size.width ? self.bounds.size.width : _contentSize.width;
        _contentSize.height = _contentSize.height < self.bounds.size.height ? self.bounds.size.height : _contentSize.height;
        return _contentSize;
    }
    else {
        return self.bounds.size;
    }
}


- (void)panGestureAction:(UIPanGestureRecognizer *)pan {

    CGFloat maxMoveWidth = 0;
    CGFloat maxMoveHeight = 0;
    CGFloat minX = 0;
    CGFloat maxX = self.contentSize.width - self.bounds.size.width;
    CGFloat minY = 0;
    CGFloat maxY = self.contentSize.height - self.bounds.size.height;

    maxMoveWidth = self.contentSize.width - self.bounds.size.width;
    maxMoveHeight = self.contentSize.height - self.bounds.size.height;

    if (maxMoveWidth <= 0 && maxMoveHeight <= 0) {
        NSLog(@"UIGestureRecognizerStateBegan");
        return;
    }

    // 记录每次滑动开始时的初始位置
    if (pan.state == UIGestureRecognizerStateBegan) {

        self.startLocation = self.bounds.origin;
        NSLog(@"self.startLocation:%@---%f--%f", NSStringFromCGPoint(self.startLocation),maxMoveWidth,maxMoveHeight);
    }

    // 相对于初始触摸点的偏移量
    CGFloat newOriginalX = 0;
    CGFloat newOriginalY = 0;
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self];
        NSLog(@"point:%@", NSStringFromCGPoint(point));
        CGFloat D_value = 0;//超越边界的差值,增加滑动的阻力效果
        if (maxMoveWidth > 0) {
            if (newOriginalX < minX) {
               D_value = minX - newOriginalX ;
            } else {
                if (newOriginalX > maxX) {
                    D_value = newOriginalX - maxX;
                }
                else {
                    D_value = 0;
                }
            }
            newOriginalX = self.startLocation.x - point.x;
        }

        if (maxMoveHeight > 0) {
            newOriginalY = self.startLocation.y - point.y;
            NSLog(@"newOriginalY:%f--%f--%f",self.startLocation.y,point.y,newOriginalY);
        }

        CGRect bounds = self.bounds;
        bounds.origin = CGPointMake(newOriginalX, newOriginalY);
        self.bounds = bounds;
        NSLog(@"self.bounds:%@",NSStringFromCGRect(self.bounds));
    }

    if (pan.state == UIGestureRecognizerStateEnded) {
        //不同状态下的数据不能公用,是重新执行方法，所以这里newOriginalX,newOriginalY需要重新赋值
        newOriginalX = self.bounds.origin.x;
        newOriginalY = self.bounds.origin.y;
        //判断边界值
        if (newOriginalX < minX) {
            newOriginalX = minX;
        } else {
            if (newOriginalX > maxX) {
                newOriginalX = maxX;
            }
        }

        if (newOriginalY < minY) {
            newOriginalY = minY;
        } else {
            if (newOriginalY > maxY) {
                newOriginalY = maxY;
            }
        }
        CGRect bounds = CGRectMake(newOriginalX, newOriginalY, self.bounds.size.width, self.bounds.size.height);
        NSLog(@"最终的frame:%@",NSStringFromCGRect(bounds));
        [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
            self.bounds = bounds;
        } completion:^(BOOL finished) {
            
        }];

    }
}


@end
