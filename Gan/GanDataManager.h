//
//  GanDataManager.h
//  数据中心，读取、存储持久化数据
//
//  Created by sjpsega on 13-7-14.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GanDataModel;
@interface GanDataManager : NSObject
+(id)getInstance;
-(NSMutableArray *)getCompletedData;
-(NSMutableArray *)getUnCompletedData;
-(void)insertData:(GanDataModel *)data;
-(void)removeData:(GanDataModel *)data;
-(void)saveData;
@end
