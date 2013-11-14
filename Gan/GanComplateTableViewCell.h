//
//  GanComplateTableViewCell.h
//  Gan
//
//  Created by sjpsega on 13-7-21.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "MCSwipeTableViewCell.h"
#import "GanDataModel.h"

@interface GanComplateTableViewCell : MCSwipeTableViewCell
+(NSString *)getReuseIdentifier;
@property(weak,nonatomic)GanDataModel *data;
-(void)setDataValToTxt;
@end
