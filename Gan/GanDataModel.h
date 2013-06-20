//
//  GanDataModel.h
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GanDataModel : NSObject
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic)NSDate *date;
@property(nonatomic)BOOL isCompelete;
-(id)initWithContent:(NSString *)conent;
@end
