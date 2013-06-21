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
#import "GanTableViewCell.h"

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
//    self.tableView.allowsSelectionDuringEditing=YES;
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
}

-(void)addBtnEvent{
    [self.addBtn setTarget:self];
    [self.addBtn setAction:@selector(showAddDialog:)];
}

-(IBAction)showAddDialog:(id)sender{
    NSLog(@"AddDialog");
    EditorDialog *addDialog = [[EditorDialog alloc]initWithTitle:@"添加任务" showDelegate:self type:@"add"];
    [addDialog show];
}

-(void)cellDataEditHandler:(GanDataModel *)data{
    NSLog(@"cellDataEditHandler");
    EditorDialog *editDialog = [[EditorDialog alloc]initWithTitle:@"编辑任务" showDelegate:self type:@"edit"];
    editDialog.data = data;
    [editDialog show];
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
                [dataSource addObject:[[GanDataModel alloc]initWithTitle:dialog.titleTxt.text detail:dialog.detailTxt.text]];
                [self.tableView reloadData];
            }
            if([dialog.type isEqualToString:@"edit"]){
                GanDataModel *data = dialog.data;
                data.title = dialog.titleTxt.text;
                data.detail = dialog.detailTxt.text;
                [self.tableView reloadData];
            }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    GanTableViewCell *cell = (GanTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if([cell isSelected]){
//        CGRect rect = cell.frame;
//        rect.size.height = 88.f;
//        cell.frame = rect;
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView indexPathForSelectedRow] && indexPath.row == [tableView indexPathForSelectedRow].row){
        return 88.f;
    }
    return 44.f;
}

//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.backgroundColor = [[UIColor alloc]initWithRed:[self random0_1] green:[self random0_1] blue:[self random0_1] alpha:[self random0_1]];

    cell.backgroundColor = [[UIColor alloc]initWithRed:0xf6/255.f green:0xf6/255.f blue:0x34/255.f alpha:1.f];

    for ( UIView* view in cell.contentView.subviews )
    {
        view.backgroundColor = [ UIColor clearColor ];
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"GanTableViewCellIdent";
    //这里使用dequeueReusableCellWithIdentifier:cellName，发现使用自定义的cell，没有调用init函数，导致无法添加自定义事件
//    GanTableViewCell *cell = (GanTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellName];
//    if(cell == nil){
//        cell = [[GanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
//    }
    
    GanTableViewCell *cell = [[GanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    cell.viewController = self;
    return cell;
}

-(CGFloat)random0_1{
    return (CGFloat)(arc4random()%100/100.0f);
}
@end
