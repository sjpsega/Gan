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
        _content = @"";
        _date = [NSDate date];
        _isCompelete = false;
    }
    return self;
}

-(id)initWithContent:(NSString *)conent{
    self = [self init];
    self.content = conent;
    return self;
}
@synthesize content=_content;
@synthesize date = _date;
@synthesize isCompelete = _isCompelete;
@end
