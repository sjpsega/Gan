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
        _isCompelete = NO;
        _isNew = YES;
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
    _isNew = NO;
}

-(void)setIsCompelete:(BOOL)isCompelete{
    _isCompelete = isCompelete;
    _date = [NSDate date];
}

#pragma mark implement NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeBool:_isCompelete forKey:@"isComplate"];
    [aCoder encodeBool:_isNew forKey:@"isNew"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.isCompelete = [aDecoder decodeBoolForKey:@"isComplate"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _isNew = [aDecoder decodeBoolForKey:@"isNew"];
    }
    return self;
}

#pragma mark implement NSCopying
-(id)copyWithZone:(NSZone *)zone{
    GanDataModel *data;
    data = [[[self class]allocWithZone:zone]initWithContent:_content];
    return data;
}

@end
