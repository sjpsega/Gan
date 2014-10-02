//
//  GanComplateTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-7-21.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanComplateTableViewCell.h"
#import "GanConstants.h"

static const NSString *ReuseIdentifier = @"GanComplateTableViewCellIdentifier";
@class MCSwipeTableViewCell;

@implementation GanComplateTableViewCell

+ (NSString *)reuseIdentifier{
    return ReuseIdentifier.copy;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addLine];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    DLog(@"willMoveToSuperview~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super willMoveToSuperview:newSuperview];
    self.textLabel.text = self.data.content;
}

- (void)setDataValToTxt{
    self.textLabel.text = self.data.content;
}

- (void)dealloc{
    [self clear];
}

- (void)clear{
    if(self.data){
        @try {
            [self.data removeObserver:self forKeyPath:@"isCompelete"];
        }
        @catch (NSException *exception) {
            DLog(@"exception:%@",exception);
        }
        @finally {
            
        }
    }
}

- (void)setData:(GanDataModel *)data{
    [self clear];
    [super setData:data];
    [self.data addObserver:self forKeyPath:@"isCompelete" options:NSKeyValueObservingOptionNew context:(__bridge void *)(self)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == (__bridge void *)(self)) {
        //空实现，只需要取消本地提醒即可
        if([keyPath isEqualToString:@"isComplete"]){
            if([self.data.remindDate compare:[NSDate date]] == NSOrderedDescending){
                [[GanLocalNotificationManager sharedInstance] registeredLocalNotify:self.data];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
