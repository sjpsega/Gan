//
//  GanViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanViewController.h"
#import "GanDataModel.h"
#import "EditorDialog.h"
@interface GanViewController (){
    NSMutableArray *dataSource;
}

@end

@implementation GanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initDataSource];
    [self addBtnEvent];
}

-(void)initDataSource{
    dataSource = [NSMutableArray arrayWithArray:
                  @[[[GanDataModel alloc]initWithContent:@"aaa"],
                   [[GanDataModel alloc]initWithContent:@"BBB"],
                   [[GanDataModel alloc]initWithContent:@"d"],
                   [[GanDataModel alloc]initWithContent:@"e"],
                   [[GanDataModel alloc]initWithContent:@"f"]]];
}

-(void)addBtnEvent{
    [self.addBtn setTarget:self];
    [self.addBtn setAction:@selector(showAddDialog:)];
}

-(IBAction)showAddDialog:(id)sender{
    NSLog(@"AddDialog");
//    [[EditorDialog class]setAnimationsEnabled:FALSE];
    EditorDialog *addDialog = [[EditorDialog alloc]initWithTitle:@"增加新任务" showDelegate:self type:@"add"];
    [addDialog show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    EditorDialog *dialog = (EditorDialog *)alertView;
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel Button Pressed");
            break;
        case 1:
            NSLog(@"Button 1 Pressed type:%@",((EditorDialog *)alertView).type);
            if([dialog.type isEqualToString:@"add"]){
                [dataSource addObject:[[GanDataModel alloc]initWithContent:dialog.titleTxt.text]];
                [self.tableView reloadData];
            }
            if([dialog.type isEqualToString:@"editor"]){
                
            }
            break;
        case 2:
            NSLog(@"Button 2 Pressed");
            break;
        case 3:
            NSLog(@"Button 3 Pressed");
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setAddBtn:nil];
    [self setAddBtn:nil];
    [super viewDidUnload];
}

//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

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
