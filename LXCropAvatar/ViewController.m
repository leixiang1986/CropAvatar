//
//  ViewController.m
//  LXCropAvatar
//
//  Created by 雷祥 on 2017/9/12.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ViewController.h"
#import "OKCropImageViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UIImagePickerController *imagePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitle:@"选取图片" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
}


- (void)btnClick:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选取图片" message:@"选择需要编辑的图片" preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"选择图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self showPhotoLibrary];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self showCamera];
    }]];

//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = @"测试TextFieldWithConfiguration";
//    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [self presentViewController:alertVC animated:YES completion:^{

    }];
}

- (void)showPhotoLibrary {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    _imagePicker = imagePicker;
}

- (void)showCamera {
    BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!isCameraSupport) {
        NSLog(@"不支持拍照");
        return ;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//    imagePicker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*45/180);

    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 55, self.view.frame.size.width, 55)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemCancel) target:self action:@selector(cancelCamera)];
    UIBarButtonItem *savePhoto = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(savePhoto)];
    tool.items = @[cancel,savePhoto];
//    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [btn setFrame:CGRectMake(0, 0, 100, 100)];
    imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    if (imagePicker.isNavigationBarHidden) {
        imagePicker.navigationBarHidden = NO;
        NSLog(@"不隐藏导航栏");
    }
    imagePicker.title = @"拍照";

//    imagePicker.cameraOverlayView = tool;
    [self presentViewController:imagePicker animated:YES completion:^{

    }];
    _imagePicker = imagePicker;
}



- (void)savePhoto {
    _imagePicker.cameraViewTransform = CGAffineTransformMakeScale(2, 2);
//    [_imagePicker takePicture];
}


- (void)cancelCamera {
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    OKCropImageViewController *vc = [[OKCropImageViewController alloc] init];
    vc.image = original;
    vc.doneClick = ^(OKCropImageViewController *vc, UIImage *editedImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 100, 100)];
        imageView.image = editedImage;
        [self.view addSubview:imageView];
        [vc.navigationController popViewControllerAnimated:YES];
    };
    vc.cancelClick = ^(OKCropImageViewController *vc) {
        [vc.navigationController popViewControllerAnimated:YES];
    };

    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
