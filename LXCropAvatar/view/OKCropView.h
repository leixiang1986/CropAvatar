//
//  OKCropView.h
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OKCropView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGSize cropSize;
- (instancetype)initWithFrame:(CGRect)frame cropSize:(CGSize)size;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE; 

/**
 * 获取剪切后的图片
 */
- (UIImage *)cropedImage;

@end
