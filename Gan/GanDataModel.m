//
//  GanDataModel.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDataModel.h"

@implementation GanDataModel
-(id)init{
    if(self = [super init]){
        _title = @"";
        _detail = @"";
        _date = [NSDate date];
        _isCompelete = false;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title detail:(NSString *)detail{
    self = [self init];
    self.title = title;
    self.detail = detail;
    return self;
}

@synthesize title = _title;
@synthesize detail = _detail;
@synthesize date = _date;
@synthesize isCompelete = _isCompelete;
@end
