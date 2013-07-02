//
//  GanViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanViewController.h"
#import "GanDataModel.h"
#import "GanTableViewCell.h"

@interface GanViewController (){
    NSMutableArray *dataSource;
    NSIndexPath *currentIndexPath;
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
//    dataSource = [NSMutableArray arrayWithArray:
//                  @[
//                  [[GanDataModel alloc]initWithTitle:@"aaa" detail:@"aaaDetail"],
//                  [[GanDataModel alloc]initWithTitle:@"bbb" detail:@"bbbDetail"],
//                  [[GanDataModel alloc]initWithTitle:@"ccc" detail:@"cccDetail"],
//                  [[GanDataModel alloc]initWithTitle:@"ddd" detail:@"dddDetail"],
//                  [[GanDataModel alloc]initWithTitle:@"eee" detail:@"eeeDetail"],
//                  [[GanDataModel alloc]initWithTitle:@"fff" detail:@"fffDetail"]]];
    
    dataSource = [NSMutableArray arrayWithArray:
                  @[
                  [[GanDataModel alloc]initWithContent:@"aaa"],
                  [[GanDataModel alloc]initWithContent:@"bbb"]]];
}

-(void)addBtnEvent{
    [self.addBtn setTarget:self];
    [self.addBtn setAction:@selector(addOne:)];
}

-(IBAction)addOne:(id)sender{
    
    [dataSource insertObject:[[GanDataModel alloc]initWithContent:@""] atIndex:0];
    NSLog(@"add");
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

-(void)deleteCell:(GanDataModel*)data{
    NSInteger index = [dataSource indexOfObject:data];
    
    NSLog(@"delete %i",index);
    [dataSource removeObject:data];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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

//- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView
//           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"editingStyleForRowAtIndexPath %i",self.editing);
//    return self.editing ?
//    UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    GanTableViewCell *cell = (GanTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell setEditing:YES animated:YES];
    [self.tableView setEditing:YES animated:YES];
    NSLog(@"didSelectRowAtIndexPath");
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
//           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"editingStyleForRowAtIndexPath~~~~~~~~~~~");
////    if (indexPath.section == 1) {
//        NSInteger ct =
//        [self tableView:tableView numberOfRowsInSection:indexPath.section];
//        if (ct-1 == indexPath.row)
//            return UITableViewCellEditingStyleInsert;
//        return UITableViewCellEditingStyleDelete;
////    }
////    return UITableViewCellEditingStyleNone;
//}

//- (BOOL)tableView:(UITableView *)tableView
//shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1)
//        return YES;
//    return NO;
//}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView indexPathForSelectedRow].row == indexPath.row) {
        return YES;
    }
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [[UIColor alloc]initWithRed:0xf6/255.f green:0xf6/255.f blue:0x34/255.f alpha:1.f];

    for ( UIView* view in cell.contentView.subviews )
    {
        view.backgroundColor = [ UIColor clearColor ];
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"GanTableViewCellIdentifier";
    //这里使用dequeueReusableCellWithIdentifier:cellName，发现使用自定义的cell，没有调用init函数
    //storyboard情况下，cell init使用的是awakeFromNib方法
    GanTableViewCell *cell = (GanTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[GanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
//    GanTableViewCell *cell = [[GanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    cell.viewController = self;
    return cell;
}

-(CGFloat)random0_1{
    return (CGFloat)(arc4random()%100/100.0f);
}
@end
