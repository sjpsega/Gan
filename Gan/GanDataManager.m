//
//  GanDataManager.m
//  Gan
//
//  Created by sjpsega on 13-7-14.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDataManager.h"
static id _instance;

@interface GanDataManager ()
@property(nonatomic)BOOL isRead;
@property(nonatomic,strong)NSMutableArray *datas;
-(NSString *)getFileName;
@end
@implementation GanDataManager

+(id)getInstance{
    if(!_instance){
        NSLog(@"GanDataManager getInstance");
        _instance = [[GanDataManager alloc]init];
    }
    return _instance;
}

-(NSMutableArray *)getData{
    if(!_isRead){
        [self readData];
        _isRead = YES;
        if(_datas == NULL){
            _datas = [[NSMutableArray alloc]init];
        }
    }
    return _datas;
}

-(void)readData{
    NSString *path = [self getFileName];
    NSLog(@"readData   %@",path);
    _datas=[[NSMutableArray alloc]initWithContentsOfFile:path];
}

-(void)saveData{
    NSLog(@"saveData....");
    NSString *path = [self getFileName];
//    NSMutableArray *aa = [NSMutableArray arrayWithArray:@[@"aaa",@"bbb"]];
    if([_datas writeToFile:path atomically:NO]){
        NSLog(@"save success!");
    }
}


-(NSString *)getFileName{
//    return [[NSBundle mainBundle]pathForResource:@"GanDatas" ofType:@"plist"];
//    return [NSTemporaryDirectory() stringByAppendingString:@"GanDatas.plist"];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [Path stringByAppendingPathComponent:@"GanDatas.plist"];
}
@end
