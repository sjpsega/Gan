//
//  GanViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanUnComplateViewController.h"
#import "GanDataModel.h"
#import "GanUnComplateTableViewCell.h"
#import "GanTableViewCellDelegate.h"
#import "GanDataManager.h"
#import "DLog.h"
static const CGFloat CELL_HEIGHT=44.0f;

@interface GanUnComplateViewController ()<GanTableViewCellDelegate>{
    NSMutableArray *dataSource;
    UIButton *maskLayer;
    CGPoint savedContentOffset;
    GanDataManager *dataManager;
}

@end

@implementation GanUnComplateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self initDataSource];
    [self addAddBtnEvent];
    [self addMaskLayer];
    [self setBgColor];
    dataManager = [GanDataManager getInstance];
//    self.tableView.allowsSelectionDuringEditing=YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setAddBtn:nil];
    [super viewDidUnload];
}

-(void)initDataSource{
    dataSource = [dataManager getUnCompletedData];
    DLog(@"dataSouce unComplate count:%i",[dataSource count]);
}

-(void)setBgColor{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
}

-(void)addAddBtnEvent{
    [self.addBtn setTarget:self];
    [self.addBtn setAction:@selector(addOne:)];
}

-(void)addMaskLayer{
    maskLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = self.tableView.frame;
    frame.origin.y +=CELL_HEIGHT;
    [maskLayer setFrame:frame];
    [maskLayer setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [self.view insertSubview:maskLayer aboveSubview:self.tableView];
    [maskLayer addTarget:self action:@selector(blurCell:) forControlEvents:UIControlEventTouchUpInside];
    [self hideMaskLayer];
}

-(void)showMaskLayer{
    [maskLayer setHidden:NO];
}

-(void)hideMaskLayer{
    [maskLayer setHidden:YES];
}

-(IBAction)blurCell:(id)sender{
    DLog(@"blurCell~~~~~~");
    [self blurCell];
}

-(IBAction)addOne:(id)sender{
    savedContentOffset = CGPointZero;
    DLog(@"add");
    [dataManager insertData:[[GanDataModel alloc]initWithContent:@""]];
    dataSource = [dataManager getUnCompletedData];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
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
    DLog(@"didSelectRowAtIndexPath %@ %@",[tableView indexPathForSelectedRow],indexPath);
}


//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
//           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"editingStyleForRowAtIndexPath~~~~~~~~~~~");
////    if (indexPath.section == 1) {
////        NSInteger ct =
//        [self tableView:tableView numberOfRowsInSection:indexPath.section];
////        if (ct-1 == indexPath.row)
////            return UITableViewCellEditingStyleInsert;
////        return UITableViewCellEditingStyleDelete;
////    }
////    return UITableViewCellEditingStyleNone;
//}

//- (BOOL)tableView:(UITableView *)tableView
//shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
////    if (indexPath.section == 1)
//        return YES;
////    return NO;
//    
//}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"canEditRowAtIndexPath %@ %@ %i",[tableView indexPathForSelectedRow],indexPath,[tableView indexPathForSelectedRow].row == indexPath.row);
//    if ([tableView indexPathForSelectedRow].row == indexPath.row) {
//        return YES;
//    }
//    return NO;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"willBeginEditingRowAtIndexPath");
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"commitEditingStyle.....");
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellForRowAtIndexPath %@",tableView.indexPathForSelectedRow);
    NSString *cellName = [GanUnComplateTableViewCell getReuseIdentifier];
    //这里使用dequeueReusableCellWithIdentifier:cellName，发现使用自定义的cell，没有调用init函数
    //storyboard情况下，cell init使用的是awakeFromNib方法
    GanUnComplateTableViewCell *cell = (GanUnComplateTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[GanUnComplateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    // For the delegate callback
    [cell setDelegate:self];
    
    // We need to provide the icon names and the desired colors
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]
            secondStateIconName:@"check.png"
                    secondColor:NULL
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:0.5]
                 fourthIconName:@"cross.png"
                    fourthColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]];
    
    // We need to set a background to the content view of the cell
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0xf6/255.f green:0xf6/255.f blue:0x34/255.f alpha:1]];
    
    // Setting the type of the cell
    [cell setMode:MCSwipeTableViewCellModeExit];
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    return cell;
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
    DLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    
    if (mode == MCSwipeTableViewCellModeExit) {
        GanDataModel *data = ((GanUnComplateTableViewCell *)cell).data;
        //完成
        if(state == MCSwipeTableViewCellState1 || state == MCSwipeTableViewCellState2){
            [data setIsCompelete:YES];
            dataSource = [dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
        }
        //删除
        else if(state == MCSwipeTableViewCellState4){
            [dataManager removeData:data];
            dataSource = [dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
        }
    }
}

-(void)deleteCell:(GanDataModel*)data{
    NSInteger index = [dataSource indexOfObject:data];
    DLog(@"delete %i",index);
    [dataManager removeData:data];
    dataSource = [dataManager getUnCompletedData];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)focusCell:(MCSwipeTableViewCell *)cell{
    savedContentOffset = [self.tableView contentOffset];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView setContentOffset:CGPointMake(0,CELL_HEIGHT * indexPath.row) animated:YES];
    [self showMaskLayer];
}

-(void)blurCell{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self hideMaskLayer];
    [self.tableView setContentOffset:savedContentOffset animated:YES];
    [dataManager saveData];
}
@end
