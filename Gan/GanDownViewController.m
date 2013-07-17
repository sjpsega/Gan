//
//  GanDownViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanDownViewController.h"
#import "GanDataModel.h"
#import "GanTableViewCell.h"
#import "GanDataManager.h"
@interface GanDownViewController ()<GanTableViewCellDelegate>{
    NSMutableArray *dataSource;
}

@end

@implementation GanDownViewController

- (void)viewDidLoad
{
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initDataSource];
    //    self.tableView.allowsSelectionDuringEditing=YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)initDataSource{
//    dataSource = [NSMutableArray arrayWithArray:
//                  @[
//                  [[GanDataModel alloc]initWithContent:@"aaa"],
//                  [[GanDataModel alloc]initWithContent:@"bbb"],
//                  [[GanDataModel alloc]initWithContent:@"ccc"],
//                  [[GanDataModel alloc]initWithContent:@"ddd"],
//                  [[GanDataModel alloc]initWithContent:@"eee"],
//                  [[GanDataModel alloc]initWithContent:@"fff"]]];
    
    
    //    [self.tableView setEditing:YES animated:YES];
    
    
    //TODO:filter已完成的数据
    dataSource = [[GanDataManager getInstance] getData];
    NSPredicate *bPredicate =
    [NSPredicate predicateWithFormat:@"SELF.isCompelete==YES"];
    NSArray *beginWithB =
    [dataSource filteredArrayUsingPredicate:bPredicate];
    dataSource = [NSMutableArray arrayWithArray:beginWithB];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellForRowAtIndexPath %@",tableView.indexPathForSelectedRow);
    static NSString *cellName = @"GanTableViewCellIdentifier";
    //这里使用dequeueReusableCellWithIdentifier:cellName，发现使用自定义的cell，没有调用init函数
    //storyboard情况下，cell init使用的是awakeFromNib方法
    GanTableViewCell *cell = (GanTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[GanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    // For the delegate callback
    [cell setDelegate:self];
    
    // We need to provide the icon names and the desired colors
    [cell setFirstStateIconName:@"cross.png"
                     firstColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]
            secondStateIconName:@"cross.png"
                    secondColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]
                 fourthIconName:@"cross.png"
                    fourthColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]];
    
    // We need to set a background to the content view of the cell
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]];
    
    // Setting the type of the cell
    [cell setMode:MCSwipeTableViewCellModeExit];
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    return cell;
}

@end
