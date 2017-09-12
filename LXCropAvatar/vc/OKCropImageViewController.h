//
//  OKCropImageViewController.h
//  OkdeerSeller
//
//  Created by 雷祥 on 2017/9/11.
//  Copyright © 2017年 Okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OKCropView;
@class OKCropBottomView;

@interface OKCropImageViewController : UIViewController
@property (nonatomic, strong) UIImage *image;   //必须设置参数
@property (nonatomic, assign) CGRect cropRect;  //可选参数,剪切所在圆形的位置,默认居中，size:(200,200)
@property (nonatomic, strong, readonly) OKCropView *cropView;
@property (nonatomic, strong, readonly) OKCropBottomView *bottomView;
@property (nonatomic, copy) void(^doneClick)(OKCropImageViewController *vc,UIImage *editedImage);
@property (nonatomic, copy) void(^cancelClick)(OKCropImageViewController *vc);
@end
