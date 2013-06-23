//
//  GanDataModel.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDataModel.h"

@implementation GanDataModel
@synthesize content = _content;
@synthesize date = _date;
@synthesize isCompelete = _isCompelete;
@synthesize isNew = _isNew;

-(id)init{
    if(self = [super init]){
        _content = @"";
        _date = [NSDate date];
        _isCompelete = false;
        _isNew = true;
    }
    return self;
}

-(id)initWithContent:(NSString *)content{
    self = [self init];
    _content = content;
    return self;
}

-(void)setContent:(NSString *)content{
    _content = content;
    _isNew = false;
}

@end
