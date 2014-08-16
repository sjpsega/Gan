//
//  GanDataModel.h
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GanDataModel : NSObject<NSCoding, NSCopying>
@property(copy, readonly, nonatomic)NSString *uuid; //唯一id，v1.4新增
@property(copy, nonatomic)NSString *content; //内容
@property(strong, readonly, nonatomic)NSDate *modifyDate; //修改时间，原先的字段为date，v1.4修改
@property(strong, nonatomic)NSDate *remindDate; //设置提醒时间，v1.4新增
@property(assign ,nonatomic)BOOL isCompelete; //是否完成
//分辩数据是否为新增，防止增加新数据的时候，在cell的selected判断中，数据因为为空，就被清除
@property(readonly, nonatomic)BOOL isNew; //是否新增
- (id)initWithContent:(NSString *)content;
@end
