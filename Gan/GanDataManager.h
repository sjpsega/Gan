//
//  GanDataManager.h
//  Gan
//
//  Created by sjpsega on 13-7-14.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GanDataManager : NSObject
+(id)getInstance;
-(NSMutableArray *)getData;
-(void)saveData;
@end
