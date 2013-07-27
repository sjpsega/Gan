//
//  GanDataModel.h
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GanDataModel : NSObject<NSCoding,NSCopying>
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic,readonly)NSDate *date;
@property(nonatomic)BOOL isCompelete;
//分辩数据是否为新增，防止增加新数据的时候，在cell的selected判断中，数据因为为空，就被清除
@property(nonatomic,readonly)BOOL isNew;
-(id)initWithContent:(NSString *)content;
@end
