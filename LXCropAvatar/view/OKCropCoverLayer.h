//
//  OKCoverLayer.h
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/11.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface OKCropCoverLayer : CALayer
@property (nonatomic, strong) UIColor *circleBorderColor;

- (void)setOvalInRect:(CGRect)rect;

@end
