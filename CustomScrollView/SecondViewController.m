//
//  SecondViewController.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "SecondViewController.h"
#import "OKCropView.h"

@interface SecondViewController ()
@property (nonatomic, strong) OKCropView *cropView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.cropView.image = [UIImage imageNamed:@"2"];
    [self.view addSubview:self.cropView];
//    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (OKCropView *)cropView {
    if (!_cropView) {
        CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
        _cropView = [[OKCropView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight - 80 - 60)];
        _cropView.backgroundColor = [UIColor lightGrayColor];
    }

    return _cropView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.




}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
