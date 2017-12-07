//
//  BaseModel.h
//  ShangPinJiaZu
//
//  Created by macbook on 16/10/26.
//  Copyright © 2016年 yangzhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface BaseModel : NSObject

- (instancetype)initWithDic:(NSDictionary *)dic;

- (instancetype)initWithSelf:(BaseModel *)model;
@end
