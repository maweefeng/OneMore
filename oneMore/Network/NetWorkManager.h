//
//  NetWorkManager.h
//  ShangPinJiaZu
//
//  Created by shenyanlong on 16/10/15.
//  Copyright © 2016年 shenyanlong. All rights reserved.
//

#import <Foundation/Foundation.h>

//引入AFNetworking框架
#import <AFNetworking.h>

@interface NetWorkManager : NSObject
@property (nonatomic, copy) NSString *severLocalAddressStr;
+ (NetWorkManager *)shareManager;
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
                     failure:(void(^)(NSError *error))conError;

/**
 *  POST 网络请求 --- 现用作上传视频 --- 修改后
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
                      failure:(void(^)(NSError *error))conError;

/**
 *  connectionRequest 网络请求
 *
 *  @param url     请求的网址
 *  @param dic     请求需要的参数
 *  @param success 请求成功的回调
 *  @param conError   请求失败的回调
 */
+ (void)connectionRequestForPOSTWithUrl:(NSString *)url
                              parameter:(NSDictionary *)dic
                                success:(void(^)(id responseObject))success
                                failure:(void(^)(NSError *error))conError;

/**
 检查手机网络

 */
- (void)judgeNetConnectWithBlock:(void(^)(void))blockAction;


/**
 上传图片
 
 @param url        请求上传的地址
 @param dic        参数
 @param imageArray 图片数组
 @param success    成功回调
 @param failure   失败回调
 */
+ (void)uploadimagesPOSTWithUrl:(NSString *)url parameter:(NSDictionary *)dic images:(NSArray *)imageArray progress:(void (^)(NSProgress *uploadProgress))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

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
+ (void)upLoadToUrlString:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;




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

+(void)POST:(NSString *)URLString images:(NSArray *)images imageParmeters:(NSArray *)imageParmeters
 parameters:(id)parameters
   progress:(void (^)(NSProgress *uploadProgress))progress
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;


/**
 下载视频
 */
+ (void)downLoadVideoWithUrl:(NSString *)urlString progress:(void (^)(NSProgress *))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure;


/**
 wooyun接口

 @param httpUrl 请求接口
 @param HttpArg 请求参数
 */
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure;
@end
