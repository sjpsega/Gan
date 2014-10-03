//
//  GanDataManager.m
//  Gan
//
//  Created by sjpsega on 13-7-14.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDataManager.h"
#import "GanDataModel.h"

@interface GanDataManager ()
@property(nonatomic)BOOL isRead;
@property(nonatomic,strong)NSMutableArray *datas;
-(NSMutableArray *)data;
-(NSString *)fileName;
@end

@implementation GanDataManager

+ (id)sharedInstance{
    static GanDataManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray *)data{
    if(!_isRead){
        [self readData];
        _isRead = YES;
        DLog(@"getData,%@",_datas);
        if(_datas == NULL){
            _datas = [self returnInitData];
        }
    }
    //找出content非空的数据，防止数据错误
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.content!=''"];
    NSArray *arr = [_datas filteredArrayUsingPredicate:predicate];
    _datas = [NSMutableArray arrayWithArray:arr];
    return _datas;
}

- (NSArray *)completedData{
    if(!_isRead){
        [self data];
    }
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.isComplete==YES"];
    NSArray *arr =
    [_datas filteredArrayUsingPredicate:predicate];
    arr = [self returnSortedArray:arr];
    return [arr copy];
}

- (NSArray *)unCompletedData{
    if(!_isRead){
        [self data];
    }
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.isComplete==NO"];
    NSArray *arr =
    [_datas filteredArrayUsingPredicate:predicate];
    arr = [self returnSortedArray:arr];
    return [arr copy];
}

- (void)insertData:(GanDataModel *)data{
    if(!_isRead){
        [self data];
    }
    [_datas insertObject:data atIndex:0];
}

- (void)removeData:(GanDataModel *)data{
    if(!_isRead){
        [self data];
    }
    [_datas removeObject:data];
}

- (void)readData{
    NSString *path = [self fileName];
    DLog(@"readData   %@",path);
    NSData *saveData = [[NSData alloc]initWithContentsOfFile:path];
    if(saveData){
        _datas = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
    }
}

- (void)saveData{
    DLog(@"saveData....");
    NSString *path = [self fileName];
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:_datas];
    NSError *error;
    if([saveData writeToFile:path options:NSDataWritingFileProtectionComplete error:&error]){
        DLog(@"save success!");
    }
}


- (NSString *)fileName{
    NSString *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [Path stringByAppendingPathComponent:@"GanDatas.plist"];
}

//降序排列
- (NSArray *)returnSortedArray:(NSArray *)array{
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(GanDataModel*)a modifyDate];
        NSDate *second = [(GanDataModel*)b modifyDate];
        return [second compare:first];
    }];
    return sortedArray;
}

- (NSMutableArray *)returnInitData{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:
                    @[[[GanDataModel alloc]initWithContent:NSLocalizedString(@"unComplateItem5", @"click icon at right side to remind")],
                      [[GanDataModel alloc]initWithContent:NSLocalizedString(@"unComplateItem4", @"swipe task right to delete it")],
                      [[GanDataModel alloc]initWithContent:NSLocalizedString(@"unComplateItem3", @"swipe task left to complete it")],
                      [[GanDataModel alloc]initWithContent:NSLocalizedString(@"unComplateItem2", @"double click to edit task")],
                      [[GanDataModel alloc]initWithContent:NSLocalizedString(@"unComplateItem1", @"click '+' button to add new task")]]];
    GanDataModel *tempData;
    tempData = [[GanDataModel alloc]initWithContent:NSLocalizedString(@"complateItem1", @"swipe task left to set it incomplete")];
    tempData.isComplete = YES;
    [arr addObject:tempData];
    
    tempData = [[GanDataModel alloc]initWithContent:NSLocalizedString(@"complateItem2", @"swipe task right to delete it")];
    tempData.isComplete = YES;
    [arr addObject:tempData];
    
    tempData = [[GanDataModel alloc]initWithContent:NSLocalizedString(@"complateItem3", @"click 'trash' to delete all completed")];
    tempData.isComplete = YES;
    [arr addObject:tempData];
    
    return arr;
}
@end
