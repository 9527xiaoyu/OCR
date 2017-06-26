//
//  ViewController.m
//  OCR
//
//  Created by yxy on 17/6/26.
//  Copyright © 2017年 霜月. All rights reserved.
//

#import "ViewController.h"
#import "RecogizeCardManager.h"
#import "RecogizeCardAll.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *imgagePickController;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    imgagePickController = [[UIImagePickerController alloc] init];
    imgagePickController.delegate = self;
    imgagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imgagePickController.allowsEditing = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//拍照
- (IBAction)cameraAction:(id)sender {
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imgagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置摄像头模式（拍照，录制视频）为拍照
        imgagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imgagePickController animated:YES completion:nil];
    } else {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"设备不能打开相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

//相册
- (IBAction)photoAction:(id)sender {
    imgagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgagePickController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *srcImage = nil;
    //判断资源类型
    if ([mediaType isEqualToString:@"public.image"]){
        srcImage = info[UIImagePickerControllerOriginalImage];
        self.imgView.image = srcImage;
        //识别身份证
        self.textLabel.text = @"图片插入成功，正在识别中...";
        //        [[RecogizeCardManager recognizeCardManager] recognizeCardWithImage:srcImage compleate:^(NSString *text) {
        //            NSLog(@"你好");
        //
        //            if (text != nil) {
        //                self.textLabel.text = [NSString stringWithFormat:@"识别结果：%@",text];
        //            }else {
        //                self.textLabel.text = @"请选择照片";
        //
        //                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"照片识别失败，请选择清晰、没有复杂背景的身份证照片重试！" preferredStyle:UIAlertControllerStyleAlert];
        //                UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        //                [alert addAction:okAction];
        //                [self presentViewController:alert animated:YES completion:nil];
        //            }
        //        }];
        [[RecogizeCardAll recognizeCardAll]recognizeCardAllWithImage:srcImage compleate:^(NSArray *array) {
            NSString *str=[NSString string];
            for (int i=0; i<array.count; i++) {
                [str stringByAppendingString:array[i]];
            }
            NSLog(@"str=%@",str);
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
