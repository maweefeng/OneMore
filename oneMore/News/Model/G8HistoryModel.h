//
//  G8HistoryModel.h
//  Template Framework Project
//
//  Created by Weefeng Ma on 2017/11/11.
//  Copyright © 2017年 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface G8HistoryModel : BaseModel
@property(nonatomic,copy)NSString * year;
@property(nonatomic,copy)NSString * day;
@property(nonatomic,copy)NSString * des;
@property(nonatomic,copy)NSString * lunar;
@property(nonatomic,copy)NSString * month;
@property(nonatomic,copy)NSString * pic;
@property(nonatomic,copy)NSString * title;

@end
