//
//  GanTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-6-16.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanUnComplateTableViewCell.h"
#import "GanTableViewCellDelegate.h"
#import "DLog.h"
#import "UIColor+HEXColor.h"

static const NSString *ReuseIdentifier = @"GanUnComplateTableViewCellIdentifier";
@class MCSwipeTableViewCell;

@interface GanUnComplateTableViewCell()
@property(strong,nonatomic)UITextField *contentEditTxt;
@end

@implementation GanUnComplateTableViewCell

+(NSString *)getReuseIdentifier{
    return ReuseIdentifier.copy;
}

-(void)prepareForReuse{
    DLog(@"GanTableViewCell prepareForReuse...");
}

-(NSString *)reuseIdentifier{
    return ReuseIdentifier.copy;
}

//允许删除操作，必须拖拽超过一半才行
-(BOOL)shouldMove{
    MCSwipeTableViewCellState state = [self stateWithPercentage:self.currentPercentage];
    if(self.direction == MCSwipeTableViewCellDirectionLeft && state==MCSwipeTableViewCellState3){
        return NO;
    }
    return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    DLog(@"GanTableViewCell initWithSytle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCustomElements];
        [self clearColorWithElement];
        
        UIView *bgColorView = [[UIView alloc] initWithFrame:self.bounds];
        bgColorView.backgroundColor = [UIColor colorWithHEX:CELL_EDIT_BG alpha:1.0f];
        [self setSelectedBackgroundView:bgColorView];
        
        self.textLabel.font = [UIFont fontWithName:@"Arial" size:18.0];
        self.textLabel.highlightedTextColor = [UIColor blackColor];
    }
    return self;
}

-(void)viewDidLoad{

}


//- (void)didReceiveMemoryWarning
//{
//    DLog(@"un cell didReceiveMemoryWarning");
//    [super didReceiveMemoryWarning];
////    // Dispose of any resources that can be recreated.
////    if([self isViewLoaded] && self.view.window == nil){
////        DLog(@"GanUnComplateViewController unload view");
////        self.view = nil;
////    }
//    _contentEditTxt = nil;
//    self.data = nil;
//}

-(void)initCustomElements{
    
    [self addDoubleClickEvnet];
    
    _contentEditTxt = [[UITextField alloc]init];
    _contentEditTxt.frame = CGRectMake(0,0, 320, 44);
    _contentEditTxt.font = [UIFont fontWithName:@"Arial" size:18.0];
    _contentEditTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _contentEditTxt.returnKeyType = UIReturnKeyDone;
    
    [_contentEditTxt addTarget:self action:@selector(keyboardDoneClcik:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.contentView addSubview:_contentEditTxt];
    
}

-(void)clearColorWithElement{
    for ( UIView* view in self.contentView.subviews )
    {
        view.backgroundColor = [UIColor clearColor];
    }
}

-(void)keyboardDoneClcik:(id)sender{
    [self hideKeyboard:self];
    [self setDataContent:_contentEditTxt.text];
    if([self.delegate respondsToSelector:@selector(blurCell:)]){
        [self.delegate blurCell];
    }
}

-(IBAction)hideKeyboard:(id)sender{
    [_contentEditTxt resignFirstResponder];
}

-(void)addDoubleClickEvnet{
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editHandler:)];
    doubleClick.numberOfTapsRequired = 2;
    doubleClick.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleClick];
}

-(void)editHandler:(UIGestureRecognizer *)recognizer{
    DLog(@"doubleLick");
    _contentEditTxt.text = self.textLabel.text;
    [self beginEdit];
}

-(void)beginEdit{
    _contentEditTxt.hidden = NO;
    self.textLabel.hidden = YES;
    [_contentEditTxt becomeFirstResponder];
    if([self.delegate respondsToSelector:@selector(focusCell:)]){
        [self.delegate focusCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    DLog(@"setSelected %i    %i    %@",selected,![_contentEditTxt.text isEqualToString: @""],_contentEditTxt.text);
    [super setSelected:selected animated:NO];
    // Configure the view for the selected state
    
    _contentEditTxt.hidden = YES;
    self.textLabel.hidden = NO;

    //cell失去焦点，保存编辑数据
    if(selected == NO){
        self.textLabel.text = _contentEditTxt.text;
        [self setDataContent:_contentEditTxt.text];
        [self hideKeyboard:self];
    }else{
        //新增行，自动进入编辑模式
        if([self.data.content isEqualToString:@""]){
            [self beginEdit];
        }
    }
}

-(void)setDataContent:(NSString *)content{
    if(!self.data.isNew && [content isEqualToString:@""] && [self.delegate respondsToSelector:@selector(deleteCell:)]){
        [self.delegate deleteCell:self.data];
    }
    self.data.content = content;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    DLog(@"willMoveToSuperview~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super willMoveToSuperview:newSuperview];
    self.textLabel.text = _data.content;
    _contentEditTxt.text = _data.content;
}

@end
