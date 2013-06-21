//
//  GanDownViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDownViewController.h"
#import "GanDataModel.h"
@interface GanDownViewController (){
    NSMutableArray *dataSource;
}

@end

@implementation GanDownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initDataSource{
    dataSource = [NSMutableArray arrayWithArray:
                  @[
                  [[GanDataModel alloc]initWithTitle:@"aaa" detail:@"aaaDetail"],
                  [[GanDataModel alloc]initWithTitle:@"bbb" detail:@"bbbDetail"],
                  [[GanDataModel alloc]initWithTitle:@"ccc" detail:@"cccDetail"],
                  [[GanDataModel alloc]initWithTitle:@"ddd" detail:@"dddDetail"],
                  [[GanDataModel alloc]initWithTitle:@"eee" detail:@"eeeDetail"],
                  [[GanDataModel alloc]initWithTitle:@"fff" detail:@"fffDetail"]]];

    
    //    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}


@end
