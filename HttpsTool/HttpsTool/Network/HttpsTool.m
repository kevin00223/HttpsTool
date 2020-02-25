//
//  HttpsTool.m
//  HttpsTool
//
//  Created by 李凯 on 2020/2/25.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "HttpsTool.h"
#import "AFNetworking.h"

static NSString *kBaseURL = @"";

@interface AFHttpsClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpsClient

+ (instancetype)sharedClient {
    static AFHttpsClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        client = [[AFHttpsClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] sessionConfiguration:configuration];
        //接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        //设置超时时间
        client.requestSerializer.timeoutInterval = 15;
        //安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    return client;
}

@end


@implementation HttpsTool

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpsSuccessBlock)success failure:(HttpsFailureBlock)failure {
    // 获取完整的url路径
    NSString *url = [kBaseURL stringByAppendingPathComponent:path];
    
    [[AFHttpsClient sharedClient] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpsSuccessBlock)success failure:(HttpsFailureBlock)failure {
    // 获取完整的url路径
    NSString *url = [kBaseURL stringByAppendingPathComponent:path];
    
    [[AFHttpsClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)downloadWithPath:(NSString *)path success:(HttpsSuccessBlock)success failure:(HttpsFailureBlock)failure progress:(HttpsDownloadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseURL stringByAppendingPathComponent:path];
    
    //下载
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpsClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
        
    }];
    
    [downloadTask resume];
}

+ (void)uploadImageWithPath:(NSString *)path params:(NSDictionary *)params thumbName:(NSString *)imagekey image:(UIImage *)image success:(HttpsSuccessBlock)success failure:(HttpsFailureBlock)failure progress:(HttpsUploadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseURL stringByAppendingPathComponent:path];
    
    NSData * data = UIImagePNGRepresentation(image);
    
    [[AFHttpsClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:imagekey fileName:@"01.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}

@end
