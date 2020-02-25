//
//  HttpsTool.h
//  HttpsTool
//
//  Created by 李凯 on 2020/2/25.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^HttpsSuccessBlock)(id _Nullable json);

typedef void(^HttpsFailureBlock)(NSError * _Nullable error);

typedef void(^HttpsDownloadProgressBlock)(CGFloat progress);

typedef void(^HttpsUploadProgressBlock)(CGFloat progress);

NS_ASSUME_NONNULL_BEGIN

@interface HttpsTool : NSObject

/// GET请求
/// @param path 路径
/// @param params 参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getWithPath: (NSString *)path
             params: (NSDictionary *)params
            success: (HttpsSuccessBlock)success
            failure: (HttpsFailureBlock)failure;

/// POST请求
/// @param path 路径
/// @param params 参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)postWithPath: (NSString *)path
              params: (NSDictionary *)params
             success: (HttpsSuccessBlock)success
             failure: (HttpsFailureBlock)failure;

/**
 *  下载文件
 *
 *  @param path     url路径
 *  @param success  下载成功
 *  @param failure  下载失败
 *  @param progress 下载进度
 */

+ (void)downloadWithPath:(NSString *)path
                 success:(HttpsSuccessBlock)success
                 failure:(HttpsFailureBlock)failure
                progress:(HttpsDownloadProgressBlock)progress;

/**
 *  上传图片
 *
 *  @param path     url地址
 *  @param image    UIImage对象
 *  @param imagekey   imagekey
 *  @param params  上传参数
 *  @param success  上传成功
 *  @param failure  上传失败
 *  @param progress 上传进度
 */

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpsSuccessBlock)success
                    failure:(HttpsFailureBlock)failure
                   progress:(HttpsUploadProgressBlock)progress;


@end

NS_ASSUME_NONNULL_END
