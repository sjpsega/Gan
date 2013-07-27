//
//  GanDataManager.m
//  Gan
//
//  Created by sjpsega on 13-7-14.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDataManager.h"
#import "DLog.h"
#import "GanDataModel.h"

static id _instance;

@interface GanDataManager ()
@property(nonatomic)BOOL isRead;
@property(nonatomic,strong)NSMutableArray *datas;
-(NSString *)getFileName;
@end
@implementation GanDataManager

+(id)getInstance{
    if(!_instance){
        DLog(@"GanDataManager getInstance");
        _instance = [[GanDataManager alloc]init];
    }
    return _instance;
}

-(NSMutableArray *)getData{
    if(!_isRead){
        [self readData];
        _isRead = YES;
        DLog(@"getData,%@",_datas);
        if(_datas == NULL){
            _datas = [[NSMutableArray alloc]init];
        }
    }
    //找出content非空的数据，防止数据错误
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.content!=''"];
    NSArray *arr =
    [_datas filteredArrayUsingPredicate:predicate];
    _datas = [NSMutableArray arrayWithArray:arr];
    return _datas;
}

-(NSMutableArray *)getCompletedData{
    if(!_isRead){
        [self getData];
    }
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.isCompelete==YES"];
    NSArray *arr =
    [_datas filteredArrayUsingPredicate:predicate];
//    arr = [self returnSortedArray:arr];
    return [NSMutableArray arrayWithArray:arr];
}

-(NSMutableArray *)getUnCompletedData{
    if(!_isRead){
        [self getData];
    }
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.isCompelete==NO"];
    NSArray *arr =
    [_datas filteredArrayUsingPredicate:predicate];
    arr = [self returnSortedArray:arr];
    return [NSMutableArray arrayWithArray:arr];
}

-(void)insertData:(GanDataModel *)data{
    if(!_isRead){
        [self getData];
    }
    [_datas insertObject:data atIndex:0];
}

-(void)removeData:(GanDataModel *)data{
    if(!_isRead){
        [self getData];
    }
    [_datas removeObject:data];
}

-(void)readData{
    NSString *path = [self getFileName];
    NSLog(@"readData   %@",path);
    NSData *saveData = [[NSData alloc]initWithContentsOfFile:path];
    _datas=[NSKeyedUnarchiver unarchiveObjectWithData:saveData];
}

-(void)saveData{
    NSLog(@"saveData....");
    NSString *path = [self getFileName];
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:_datas];
    if([saveData writeToFile:path atomically:YES]){
        NSLog(@"save success!");
    }
}


-(NSString *)getFileName{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [Path stringByAppendingPathComponent:@"GanDatas.plist"];
}

//降序排列
-(NSArray *)returnSortedArray:(NSArray *)array{
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(GanDataModel*)a date];
        NSDate *second = [(GanDataModel*)b date];
        return [second compare:first];
    }];
    return sortedArray;
}
@end
