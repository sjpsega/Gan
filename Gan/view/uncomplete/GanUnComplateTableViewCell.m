
//
//  GanTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-6-16.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanUnComplateTableViewCell.h"
#import "GanTableViewProtocol.h"
#import "UIColor+HEXColor.h"

static const NSString *ReuseIdentifier = @"GanUnComplateTableViewCellIdentifier";

@implementation GanUnComplateTableViewCell{
    UIImageView *_clockImgView;
}

+(NSString *)reuseIdentifier{
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
        self.isEditing = false;
        [self initCustomElements];
        [self addLine];
    }
    return self;
}

//- (void)didReceiveMemoryWarning
//{
//    DLog(@"un cell didReceiveMemoryWarning");
//    [super didReceiveMemoryWarning];
////    // Dispose of any resources that can be recreated.
////    if([self isViewLoaded] && self.view.window == nil){
////        DLog(@"GanUnComplateVC unload view");
////        self.view = nil;
////    }
//    _contentEditTxt = nil;
//    self.data = nil;
//}

-(void)initCustomElements{

    [self addContentEditTxt];
    
    [self addContentEditTxtDoubleTapEvnet];
    
    [self addClockIcon];
    
    [self addClockIconSingleTapEvent];
}

#pragma mark addContentEditTxt
-(void)addContentEditTxt{
    _contentEditTxt = [[UITextField alloc]init];
    _contentEditTxt.frame = CGRectMake(0,0, UI_SCREEN_WIDTH, 44);
    _contentEditTxt.font = [UIFont fontWithName:@"Arial" size:18.0];
    _contentEditTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _contentEditTxt.returnKeyType = UIReturnKeyDone;
    [_contentEditTxt addTarget:self action:@selector(keyboardDoneClcik:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.contentView addSubview:_contentEditTxt];
}

-(void)keyboardDoneClcik:(id)sender{
    [self hideKeyboard:self];
    [self setDataContent:_contentEditTxt.text];
    if([self.delegate respondsToSelector:@selector(blurCell:)]){
        self.isEditing = false;
        [self.delegate blurCell];
    }
}

-(void)hideKeyboard:(id)sender{
    [_contentEditTxt resignFirstResponder];
}

-(void)addContentEditTxtDoubleTapEvnet{
    _contentEditTxt.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editHandler:)];
    doubleClick.numberOfTapsRequired = 2;
    doubleClick.numberOfTouchesRequired = 1;
    //因为默认_contentEditTxt为隐藏，所以双击编辑，需要挂到self(TableViewCell)上，不能挂到_contentEditTxt上
    [self addGestureRecognizer:doubleClick];
}

-(void)editHandler:(UIGestureRecognizer *)recognizer{
    //如果双击的位置是clockImg的为止，则不进行编辑
    CGPoint touchPoint = [recognizer locationInView:self];
    BOOL isTouchImgView = CGRectContainsPoint(_clockImgView.frame, touchPoint);
    if(isTouchImgView){
        return;
    }
    
    DLog(@"doubleLick");
    _contentEditTxt.text = self.textLabel.text;
    [self beginEdit];
}

-(void)beginEdit{
    _contentEditTxt.hidden = NO;
    self.textLabel.hidden = YES;
    _clockImgView.hidden = NO;
    [_contentEditTxt becomeFirstResponder];
    if([self.delegate respondsToSelector:@selector(focusCell:)]){
        self.isEditing = true;
        [self.delegate focusCell:self];
    }
}

#pragma mark addClockIcon
-(void)addClockIcon{
    UIImage *clockImg = [UIImage imageNamed:@"clock"];
    _clockImgView = [[UIImageView alloc]initWithImage:clockImg];
    CGRect frame = _clockImgView.frame;
    frame.origin = CGPointMake(UI_SCREEN_WIDTH - 30, (44 - CGRectGetHeight(frame))/2);
    _clockImgView.frame = frame;
    _clockImgView.hidden = YES;
    
    [self.contentView addSubview:_clockImgView];
}

-(void)addClockIconSingleTapEvent{
    _clockImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *clockClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editDateAction:)];
    clockClick.numberOfTapsRequired = 1;
    clockClick.numberOfTouchesRequired = 1;
    
    [_clockImgView addGestureRecognizer:clockClick];
}

-(void)editDateAction:(id)sender{
    DLog(@"editDateAction");
    if([self.delegate respondsToSelector:@selector(showPickerView)]){
        [self.delegate showPickerView];
    }
}

#pragma mark override setSelected:animated:
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    DLog(@"%i    %i    %@",selected,![_contentEditTxt.text isEqualToString: @""],_contentEditTxt.text);
    [super setSelected:selected animated:NO];
    // Configure the view for the selected state
    
    _contentEditTxt.hidden = YES;
    self.textLabel.hidden = NO;
    
    //cell失去焦点，保存编辑数据
    if(selected == NO){
        _clockImgView.hidden = YES;
        self.textLabel.text = _contentEditTxt.text;
        [self setDataContent:_contentEditTxt.text];
        [self hideKeyboard:self];
    }else{
        _clockImgView.hidden = NO;
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
    //必须放在判断后，因为content设置后isNew为NO
    self.data.content = content;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    DLog(@"willMoveToSuperview~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super willMoveToSuperview:newSuperview];
    self.textLabel.text = self.data.content;
    _contentEditTxt.text = self.data.content;
}

-(void)setDataValToTxt{
    self.textLabel.text = self.data.content;
    _contentEditTxt.text = self.data.content;
}
@end

