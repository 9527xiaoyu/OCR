//
//  RecogizeCardAll.h
//  OCR
//
//  Created by yxy on 17/5/19.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

typedef void (^RecognizeArrayBlock)(NSArray *array);

typedef void (^RecognizeTextBlock)(NSString *text);

@interface RecogizeCardAll : NSObject

/**
 *  初始化一个单例
 *
 *  @return 返回一个RecogizeCardManager的实例对象
 */
+ (instancetype)recognizeCardAll;

/**
 *  根据身份证照片得到身份证号码
 *
 *  @param cardImage 传入的身份证照片
 *  @param compleate 识别完成后的回调
 */
- (void)recognizeCardAllWithImage:(UIImage *)cardImage compleate:(RecognizeArrayBlock)compleate;

- (void)opencvScanCard:(UIImage *)image compleate:(RecognizeArrayBlock)recignizeText;;

@end
