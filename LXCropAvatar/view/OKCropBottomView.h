//
//  OKCropBottomView.h
//  OkdeerSeller
//
//  Created by 雷祥 on 2017/9/11.
//  Copyright © 2017年 Okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OKCropBottomView : UIView
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) void(^leftClickBlock)(void);
@property (nonatomic, copy) void(^rightClickBlock)(void);
@end
