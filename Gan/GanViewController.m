//
//  GanViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanViewController.h"
#import "GanDataModel.h"
@interface GanViewController (){
    NSArray *dataSource;
}

@end

@implementation GanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initDataSource];
}

-(void)initDataSource{
    dataSource = @[[[GanDataModel alloc]initWithContent:@"aaa"],
                   [[GanDataModel alloc]initWithContent:@"BBB"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"SimpleTableItem";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]).content;
    
    //设置背景颜色
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [[UIColor alloc]initWithRed:[self random0_1] green:[self random0_1] blue:[self random0_1] alpha:[self random0_1]];
    cell.backgroundView = backgroundView;
    for ( UIView* view in cell.contentView.subviews )
    {
        view.backgroundColor = [ UIColor clearColor ];
    }
    
    return cell;
}

-(CGFloat)random0_1{
    return (CGFloat)(arc4random()%100/100.0f);
}
@end
