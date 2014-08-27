//
//  GanDataModel.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDataModel.h"

@implementation GanDataModel

- (id)init{
    if(self = [super init]){
        _uuid =  [[NSUUID UUID] UUIDString];
        _content = @"";
        _modifyDate = [NSDate date];
        _remindDate = nil;
        _isCompelete = NO;
        _isNew = YES;
    }
    return self;
}

- (id)initWithContent:(NSString *)content{
    self = [self init];
    _content = content;
    return self;
}

- (void)setContent:(NSString *)content{
    _content = content;
    _isNew = NO;
}

- (void)setIsCompelete:(BOOL)isCompelete{
    _isCompelete = isCompelete;
    _modifyDate = [NSDate date];
}

#pragma mark implement NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_uuid forKey:@"uuid"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_modifyDate forKey:@"date"];
    [aCoder encodeObject:_remindDate forKey:@"remindDate"];
    [aCoder encodeBool:_isCompelete forKey:@"isComplate"];
    [aCoder encodeBool:_isNew forKey:@"isNew"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        _content = [aDecoder decodeObjectForKey:@"content"];
        _isNew = NO;
        _isCompelete = [aDecoder decodeBoolForKey:@"isComplate"];
        _uuid = [aDecoder decodeObjectForKey:@"uuid"];
        if(!_uuid){
            _uuid =  [[NSUUID UUID] UUIDString];
        }
        _modifyDate = [aDecoder decodeObjectForKey:@"date"];
        if(!_modifyDate){
            _modifyDate = [NSDate date];
        }
        _remindDate = [aDecoder decodeObjectForKey:@"remindDate"];
        _isNew = [aDecoder decodeBoolForKey:@"isNew"];
    }
    return self;
}

#pragma mark implement NSCopying
- (id)copyWithZone:(NSZone *)zone{
    GanDataModel *data;
    data = [[[self class]allocWithZone:zone]initWithContent:_content];
    return data;
}

@end
