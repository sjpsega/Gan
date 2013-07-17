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
#import "GanTableViewCellDelegate.h"
#import "GanDataManager.h"

static const CGFloat CELL_HEIGHT=44.0f;

@interface GanViewController ()<GanTableViewCellDelegate>{
    NSMutableArray *dataSource;
    UIButton *maskLayer;
    CGPoint savedContentOffset;
}

@end

@implementation GanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initDataSource];
    [self addAddBtnEvent];
    [self addMaskLayer];
//    self.tableView.allowsSelectionDuringEditing=YES;
    
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
    dataSource = [[GanDataManager getInstance] getData];
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
    NSLog(@"blurCell~~~~~~");
    [self blurCell];
}

-(IBAction)addOne:(id)sender{
    savedContentOffset = CGPointZero;
    [dataSource insertObject:[[GanDataModel alloc]initWithContent:@""] atIndex:0];
    NSLog(@"add");
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
    NSLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    
    if (mode == MCSwipeTableViewCellModeExit) {
        //完成
        if(state == MCSwipeTableViewCellState1 || state == MCSwipeTableViewCellState2){
            GanDataModel *data = ((GanTableViewCell *)cell).data;
            [data setIsCompelete:YES];
            [dataSource removeObject:data];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [[GanDataManager getInstance] saveData];
        }
        //删除
        else if(state == MCSwipeTableViewCellState4){
            [dataSource removeObject:((GanTableViewCell *)cell).data];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [[GanDataManager getInstance] saveData];
        }
    }
}

-(void)deleteCell:(GanDataModel*)data{
    NSInteger index = [dataSource indexOfObject:data];
    NSLog(@"delete %i",index);
    [dataSource removeObject:data];
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
    [[GanDataManager getInstance] saveData];
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
    NSLog(@"didSelectRowAtIndexPath %@ %@",[tableView indexPathForSelectedRow],indexPath);
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
    NSLog(@"willBeginEditingRowAtIndexPath");
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"commitEditingStyle.....");
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]
            secondStateIconName:@"check.png"
                    secondColor:NULL
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:0.5]
                 fourthIconName:@"cross.png"
                    fourthColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]];
    
    // We need to set a background to the content view of the cell
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0xf6/255.f green:0xf6/255.f blue:0x34/255.f alpha:1.f]];
    
    // Setting the type of the cell
    [cell setMode:MCSwipeTableViewCellModeExit];
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    return cell;
}

-(CGFloat)random0_1{
    return (CGFloat)(arc4random()%100/100.0f);
}
@end
