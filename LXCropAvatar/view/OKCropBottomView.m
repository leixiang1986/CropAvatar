//
//  OKCropBottomView.m
//  OkdeerSeller
//
//  Created by 雷祥 on 2017/9/11.
//  Copyright © 2017年 Okdeer. All rights reserved.
//

#import "OKCropBottomView.h"
#import "Masonry.h"



@implementation OKCropBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self leftBtn];
        [self rightBtn];

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _leftBtn.frame = CGRectMake(10, 5, 60, self.bounds.size.height - 10);
    _rightBtn.frame = CGRectMake(self.bounds.size.width - 70, 5, 60, self.bounds.size.height - 10);
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_leftBtn];
    }

    return _leftBtn;
}


- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_rightBtn];
    }

    return _rightBtn;
}


- (void)leftClick {
    if (self.leftClickBlock) {
        self.leftClickBlock();
    }
}


- (void)rightClick {
    if (self.rightClickBlock) {
        self.rightClickBlock();
    }
}


@end
