//
//  RecogizeCardAll.m
//  OCR
//
//  Created by yxy on 17/5/19.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "RecogizeCardAll.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <TesseractOCR/TesseractOCR.h>
@implementation RecogizeCardAll

+ (instancetype)recognizeCardAll {
    static RecogizeCardAll *recognizeCardAll = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recognizeCardAll = [[RecogizeCardAll alloc] init];
    });
    return recognizeCardAll;
}

- (void)recognizeCardAllWithImage:(UIImage *)cardImage compleate:(RecognizeArrayBlock)compleate {
    //扫描身份证图片，并进行预处理，定位号码区域图片并返回
    [self opencvScanCard:cardImage compleate:^(NSArray *array) {
        compleate(array);
    }];
    
    
//    //利用TesseractOCR识别文字
//    [self tesseractRecognizeImage:numberImage compleate:^(NSString *numbaerText) {
//        compleate(numbaerText);
//    }];
}


//扫描身份证图片，并进行预处理，定位号码区域图片并返回
-(void)opencvScanCard:(UIImage *)image compleate:(RecognizeArrayBlock)recignizeText{
    
    //将UIImage转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    //利用阈值二值化
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    //腐蚀，填充（腐蚀是让黑色点变大）
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(26,26));
    cv::erode(resultImage, resultImage, erodeElement);
    //轮廊检测
    std::vector<std::vector<cv::Point>> contours;//定义一个容器来存储所有检测到的轮廊
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    //cv::drawContours(resultImage, contours, -1, cv::Scalar(255),4);
    //取出身份证号码区域
    std::vector<cv::Rect> rects;
    cv::Rect numberRect = cv::Rect(0 ,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    NSMutableArray *array=[NSMutableArray array];
    for ( ; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        //算法原理
                if (rect.width > numberRect.width && rect.width > rect.height ) {
                    numberRect = rect;
                }
        
//        //识别所有区域
//        //定位成功成功，去原图截取身份证号码区域，并转换成灰度图、进行二值化处理
//        cv::Mat matImage;
//        UIImageToMat(image, matImage);
//        resultImage = matImage(rect);
//        cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
//        cv::threshold(resultImage, resultImage, 80, 255, CV_THRESH_BINARY);
//        //将Mat转换成UIImage
//        UIImage *numberImage = MatToUIImage(resultImage);
//        [self tesseractRecognizeImage:numberImage compleate:^(NSString *text) {
//            [array addObject:text];
//        }];
    }
    //身份证号码定位失败
    if (numberRect.width == 0 || numberRect.height == 0) {
        recignizeText(nil);
    }
    //定位成功成功，去原图截取身份证号码区域，并转换成灰度图、进行二值化处理
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    resultImage = matImage(numberRect);
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    cv::threshold(resultImage, resultImage, 80, 255, CV_THRESH_BINARY);
    //将Mat转换成UIImage
    UIImage *numberImage = MatToUIImage(resultImage);
    [self tesseractRecognizeImage:numberImage compleate:^(NSString *text) {
        [array addObject:text];
        NSLog(@"%@",array);
    }];
    
    recignizeText(array);
}

//利用TesseractOCR识别文字
- (void)tesseractRecognizeImage:(UIImage *)image compleate:(RecognizeTextBlock)compleate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"chi_sim" engineMode:G8OCREngineModeTesseractOnly];//语言   OCR工作模式
        tesseract.image = [image g8_blackAndWhite];
        tesseract.image = image;
        tesseract.pageSegmentationMode=G8PageSegmentationModeAuto;//自动划分页

        // Start the recognition
        [tesseract recognize];
        //执行回调
        compleate(tesseract.recognizedText);
    });
}

@end
