//
//  ViewController.m
//  CustomScrollView
//
//  Created by 雷祥 on 2017/9/8.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ViewController.h"
#import "OKCustomScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    OKCustomScrollView *scrollView = [[OKCustomScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 500)];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = CGSizeMake(200, 750);
    [self.view addSubview:scrollView];

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(100, 100, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [scrollView addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
