//
//  NetWorkManager.m
//  ShangPinJiaZu
//
//  Created by shenyanlong on 16/10/15.
//  Copyright © 2016年 shenyanlong. All rights reserved.
//

#import "NetWorkManager.h"
//#import "MBProgressHUD+Add.h"

@implementation NetWorkManager

+ (NetWorkManager *)shareManager{
    static NetWorkManager * mangager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mangager = [[NetWorkManager alloc]init];
    });
    return mangager;
}
/**
 *  GET 网络请求
 *
 *  @param url     请求的网址
 *  @param dic     请求需要的参数
 *  @param success 请求成功的回调
 *  @param conError   请求失败的回调
 */
+ (void)requestForGETWithUrl:(NSString *)url
                   parameter:(NSDictionary *)dic
                     success:(void(^)(id responseObject))success
                     failure:(void(^)(NSError *error))conError
{
    //创建一个网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置可接受的数据类型
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    //开始网络请求
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //请求数据的进度
        NSLog(@"%f", downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求数据成功   responseObject 关键!!请求得到的数据
        //将请求成功返回的结果回调回去
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //回调请求失败的错误信息
        conError(error);
    }];

}

/**
 *  POST 网络请求 --- 上传视频 --- 修改
 *
 *  @param url     请求的网址
 *  @param dic     请求需要的参数
 *  @param success 请求成功的回调
 *  @param conError   请求失败的回调
 */
+ (NSURLSessionDataTask *)requestForPOSTWithUrl:(NSString *)url
                    parameter:(NSDictionary *)dic
                     progress:(void(^)(double progressNum))progressFloat
                      success:(void(^)(id responseObject))success
                      failure:(void(^)(NSError *error))conError
{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];
    if (netManager.networkReachabilityStatus != 0) {
        AFHTTPSessionManager *manager = [self sharedHTTPSession];
        manager.requestSerializer.timeoutInterval = 300000.0f;
        //设置可接受的数据类型
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"text/html",@"application/json",@"text/plain",@"charset=ISO-8859-1",@"text/html",@"charset=utf-8", nil];
       
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
      
        manager.requestSerializer.timeoutInterval = 30.0f;
        
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSURLSessionDataTask *dataTask = [manager POST:[NSString stringWithFormat:@"%@%@", [self shareManager].severLocalAddressStr , url] parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            progressFloat(uploadProgress.fractionCompleted);
            //上传数据的进度
            NSLog(@"上传数据的进度%f", uploadProgress.fractionCompleted);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //回调请求失败的错误信息
            NSLog(@"%@", error);
            conError(error);
//            [SVProgressHUD showErrorWithStatus:@"请检查网络连接设置"];
        }];
        return dataTask;
    }else{
        NSError *error;
        conError(error);
//        [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
        return nil;
    }
}
//  session 连接 加密

+ (void)connectionRequestForPOSTWithUrl:(NSString *)url
                              parameter:(NSDictionary *)dic
                                success:(void(^)(id responseObject))success
                                failure:(void(^)(NSError *error))conError
{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];
    if (netManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable)
    {
        [self realRequestDataActionForPOSTWithUrl:url parameter:dic success:^(id responseObject) {
            success(responseObject);
        } failure:^(NSError *error) {
            conError(error);
        }];
    }
    else
    {
//        [SVProgressHUD showErrorWithStatus:@"请检查您的网络连接设置"];
    }
}

+ (AFHTTPSessionManager *)sharedHTTPSession
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 30.0f;
//        [manager.requestSerializer  setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    });
    return manager;
}
/**
 真正的数据请求在这里 !!!!
 */
+ (void)realRequestDataActionForPOSTWithUrl:(NSString *)url
                                  parameter:(NSDictionary *)dic
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))conError{
    @synchronized (self) {
        
        AFHTTPSessionManager *manager = [self sharedHTTPSession];
        //设置可接受的数据类型
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"text/html",@"application/json",@"text/plain",@"charset=ISO-8859-1",@"text/html",@"charset=utf-8",@"multipart/form-data", nil];
      
        if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown || [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN){
            manager.requestSerializer.timeoutInterval = 20.0f;
        }
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", [self shareManager].severLocalAddressStr , url] parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
            //上传数据的进度
            NSLog(@"%f", uploadProgress.fractionCompleted);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //回调请求失败的错误信息
            NSLog(@"%@", error);
            conError(error);
//            [SVProgressHUD showErrorWithStatus:@"连接失败"];
                }];
    }
}

- (void)judgeNetConnectWithBlock:(void(^)(void))blockAction{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /**
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                blockAction();
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
//                TTAlertNoTitle(@"请检查您的手机网络！");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                blockAction();
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                blockAction();
            }
                break;
                
            default:
                break;
        }
    }];
}

/**
 上传图片
 文件类型 图片:image/jpg,image/png
 @param url        请求上传的地址
 @param dic        参数
 @param imageArray 图片数组
 @param success    成功回调
 @param failure   失败回调
 */
+ (void)uploadimagesPOSTWithUrl:(NSString *)url
                      parameter:(NSDictionary *)dic
                         images:(NSArray *)imageArray
                         progress:(void (^)(NSProgress *uploadProgress))progress
                        success:(void(^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure{
    // 向服务器提交图片
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 显示进度
    [manager POST:[NSString stringWithFormat:@"%@%@", [self shareManager].severLocalAddressStr, url] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for(NSInteger i = 0; i <imageArray.count; i++)
        {
            NSDictionary *dict = imageArray[i];
            
//            NSData * imageData = UIImagePNGRepresentation([imageArray objectAtIndex: i]);
            /*
             NSDictionary *dic = @{@"imageData":imageData, @"imageName":[info valueForKey:@"PHImageFileUTIKey"],@"name":@"file",@"mimeType":@"image/gif"};
             */
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            dateString = [NSString stringWithFormat:@"%@%ld",dateString,(long)i];
            NSString *fileName;
            if ([[NSString stringWithFormat:@"%@",dict[@"mimeType"]] containsString:@"gif"]) {
                fileName = [NSString  stringWithFormat:@"%@.gif", dateString];
            }else{
                fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            }
            
            [formData appendPartWithFileData:dict[@"imageData"] name:dict[@"name"] fileName:fileName mimeType:dict[@"mimeType"]];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"完成 %@", result);
        if (success) {
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"错误 %@", error.localizedDescription);
        if (failure) {
            failure(error);
        }

    }];
    
}

/*
 发送视频
@param url 服务器地址
@param parameters 字典 token
@param fileData 要上传的数据
@param name 服务器参数名称 后台给你
@param fileName 文件名称 图片:xxx.jpg,xxx.png 视频:video.mov
视频:video/quicktime
@param progress
@param success
@param failure
*/
+ (void)upLoadToUrlString:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    //1.获取单例的网络管理对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    
    //3.设置相应数据支持的类型
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded",@"multipart/form-data", nil]];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", [self shareManager].severLocalAddressStr, url] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmssmm"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.mp4", dateString];
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:@"video/quicktime"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  POST 请求   上传照片
 *
 *  @param URLString        URL
 *  @param images           存要传的照片
 *  @param imageParmeters   与图片对应得参数
 *  @param parameters       常规参数
 *  @param progress         进程
 *  @param success          成功时回调
 *  @param failure          失败时回调
 */



+(void)POST:(NSString *)URLString images:(NSArray *)images imageParmeters:(NSArray *)imageParmeters parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imageName = [inputFormatter stringFromDate:nowDate];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            
            NSString *parmeter = [NSString string];
            if (imageParmeters.count == 0)
            {
                
            }
            else if (imageParmeters.count <= i)
            {
                parmeter = [imageParmeters lastObject];
            }
            else
            {
                parmeter = imageParmeters[i];
            }
            
            [formData appendPartWithFileData:data name:parmeter fileName:[NSString stringWithFormat:@"%@%d.jpeg",imageName,i] mimeType:@"jpeg"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 下载视频
 */
+ (void)downLoadVideoWithUrl:(NSString *)urlString progress:(void (^)(NSProgress *))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [self sharedHTTPSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2.下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调 downloadProgress
     第三个参数:destination 回调(目标位置)有返回值targetPath:临时文件路径response:响应头信息
     第四个参数:completionHandler 下载完成之后的回调filePath:最终的文件路径
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        float progressValue = 1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"%f",progressValue);
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"目标路径:%@",targetPath);
        NSLog(@"完整路径:%@",fullPath);
        success(fullPath);
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        success(filePath);
        if (error) {
            failure(error);
            NSLog(@"失败____%@",filePath);
        }
    }];
    
    //3.执行Task
    [download resume];
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@", httpUrl];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 20];
    [request setHTTPMethod: @"GET"];
    [request addValue: appkey forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   failure(error);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                                   NSError *err;
                                   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                       options:NSJSONReadingMutableContainers
                                                                                         error:&err];
                                   success(dic);
                               }
                           }];
}

@end
