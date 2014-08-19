
//
//  GanTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-6-16.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanUnComplateTableViewCell.h"
#import "GanTableViewProtocol.h"
#import "GanStringUtil.h"
#import "UIImage+Tint.h"

static const NSString *ReuseIdentifier = @"GanUnComplateTableViewCellIdentifier";
static const CGFloat PaddingLeft = 15.0f;
static NSDateFormatter *dateFormatter;

@interface GanUnComplateTableViewCell()
@end

@implementation GanUnComplateTableViewCell{
    UIImageView *_clockImgView;
    UIImageView *_remindClockImgView;
    UILabel *_remindTxt;
}

+ (NSString *)reuseIdentifier{
    return ReuseIdentifier.copy;
}

//允许删除操作，必须拖拽超过一半才行
- (BOOL)shouldMove{
    MCSwipeTableViewCellState state = [self stateWithPercentage:self.currentPercentage];
    if(self.direction == MCSwipeTableViewCellDirectionLeft && state==MCSwipeTableViewCellState3){
        return NO;
    }
    return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    DLog(@"GanTableViewCell initWithSytle");
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    });
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isEditing = false;
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

- (void)initCustomElements{

    [self addContentEditTxt];
    
    [self addContentEditTxtDoubleTapEvnet];
    
    [self addClockIcon];
    
    [self addClockIconSingleTapEvent];
    
    [self addRemindClockIcon];
    
    [self addRemindTxt];
}

#pragma mark addContentEditTxt
- (void)addContentEditTxt{
    _contentEditTxt = [[UITextField alloc]init];
    _contentEditTxt.frame = CGRectMake(PaddingLeft, 0, UI_SCREEN_WIDTH - PaddingLeft, GAN_CELL_HEIGHT);
    _contentEditTxt.font = [UIFont fontWithName:@"Arial" size:18.0];
//    _contentEditTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _contentEditTxt.returnKeyType = UIReturnKeyDone;
    [_contentEditTxt addTarget:self action:@selector(keyboardDoneClick:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_contentEditTxt addTarget:self action:@selector(keyboardEnter:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_contentEditTxt];
}

- (void)keyboardDoneClick:(id)sender{
    [self hideKeyboard:self];
    [self setDataContent:_contentEditTxt.text];
    if([self.delegate respondsToSelector:@selector(blurCell:)]){
        _isEditing = false;
        [self.delegate blurCell];
    }
}

- (void)keyboardEnter:(id)sender{
    UITextField *tf = sender;
    if([GanStringUtil isBlank:tf.text]){
        _clockImgView.hidden = YES;
    }else{
        _clockImgView.hidden = NO;
    }
}

- (void)hideKeyboard:(id)sender{
    [_contentEditTxt resignFirstResponder];
}

- (void)addContentEditTxtDoubleTapEvnet{
    _contentEditTxt.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editHandler:)];
    doubleClick.numberOfTapsRequired = 2;
    doubleClick.numberOfTouchesRequired = 1;
    //因为默认_contentEditTxt为隐藏，所以双击编辑，需要挂到self(TableViewCell)上，不能挂到_contentEditTxt上
    [self addGestureRecognizer:doubleClick];
}

- (void)editHandler:(UIGestureRecognizer *)recognizer{
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

- (void)beginEdit{
    CGRect textLabelFrame = self.textLabel.frame;
    if(!CGRectIsEmpty(textLabelFrame)){
//        textLabelFrame.size.width = UI_SCREEN_WIDTH - CGRectGetMaxX(textLabelFrame);
        _contentEditTxt.frame = textLabelFrame;
    }
    _contentEditTxt.hidden = NO;
    self.textLabel.hidden = YES;
    _clockImgView.hidden = YES;
    
    if(![GanStringUtil isBlank:_contentEditTxt.text]){
        _clockImgView.hidden = NO;
    }
    [_contentEditTxt becomeFirstResponder];
    if([self.delegate respondsToSelector:@selector(focusCell)]){
        _isEditing = true;
        [self.delegate focusCell];
    }
}

#pragma mark addClockIcon
- (void)addClockIcon{
    UIImage *clockImg = [UIImage imageNamed:@"clock"];
    _clockImgView = [[UIImageView alloc]initWithImage:clockImg];
    CGRect frame = _clockImgView.frame;
    frame.origin = CGPointMake(UI_SCREEN_WIDTH - 30, (44 - CGRectGetHeight(frame))/2);
    _clockImgView.frame = frame;
    _clockImgView.hidden = YES;
    
    [self.contentView addSubview:_clockImgView];
}

- (void)addClockIconSingleTapEvent{
    _clockImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *clockTapGestureGecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editDateAction:)];
    clockTapGestureGecognizer.numberOfTapsRequired = 1;
    clockTapGestureGecognizer.numberOfTouchesRequired = 1;
    
    [_clockImgView addGestureRecognizer:clockTapGestureGecognizer];
}

- (void)editDateAction:(id)sender{
    DLog(@"editDateAction");
    self.textLabel.text = _contentEditTxt.text;
    [self setDataContent:_contentEditTxt.text];
    _contentEditTxt.hidden = YES;
    self.textLabel.hidden = NO;
    [self hideKeyboard:self];
    if([self.delegate respondsToSelector:@selector(showDatePickerView)]){
        [self.delegate showDatePickerView];
    }
}

#pragma mark - addRemindClockIcon
- (void)addRemindClockIcon{
    UIImage *remindClockImg = [UIImage imageNamed:@"remind-clock"];
//    remindClockImg = [remindClockImg imageWithTintColor:[UIColor redColor]];
    _remindClockImgView = [[UIImageView alloc]initWithImage:remindClockImg];
    _remindClockImgView.frame = CGRectMake(PaddingLeft, 25.0f, 24.0f, 24.0f);
    _remindClockImgView.hidden = YES;
    
    [self.contentView addSubview:_remindClockImgView];
}

#pragma mark - addRemindTxt
- (void)addRemindTxt{
    _remindTxt = [[UILabel alloc]initWithFrame:CGRectMake(PaddingLeft + 25.0f, 25.0f, UI_SCREEN_WIDTH - PaddingLeft - 50.0f, 15.0f)];
    _remindTxt.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    [self addSubview:_remindTxt];
    _remindTxt.hidden = YES;
}

#pragma mark override setSelected:animated:
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    DLog(@"%i    %i    %@",selected,![_contentEditTxt.text isEqualToString: @""],_contentEditTxt.text);

    [super setSelected:selected animated:NO];

    //去除底色，否则默认是白色...
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    _contentEditTxt.hidden = YES;
    self.textLabel.hidden = NO;
    _clockImgView.hidden = YES;
    
    if(selected){
        _clockImgView.hidden = NO;
        //新增行，自动进入编辑模式
        if([self.data.content isEqualToString:@""]){
            [self beginEdit];
        }
    }else{
        //cell失去焦点，保存编辑数据
        self.textLabel.text = _contentEditTxt.text;
        [self setDataContent:_contentEditTxt.text];
        [self hideKeyboard:self];
    }
    [self changeStateForRemindDate];
}

- (void)setDataContent:(NSString *)content{
    if(!self.data.isNew && [content isEqualToString:@""] && [self.delegate respondsToSelector:@selector(deleteCell:)]){
        [self.delegate deleteCell:self.data];
    }
    //必须放在判断后，因为content设置后isNew为NO
    self.data.content = content;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    DLog(@"willMoveToSuperview~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super willMoveToSuperview:newSuperview];
    self.textLabel.text = self.data.content;
    _contentEditTxt.text = self.data.content;
}

- (void)changeStateForRemindDate{
    if(self.data.remindDate){
        DLog(@"%@",[dateFormatter stringFromDate:self.data.remindDate]);
//        self.detailTextLabel.text = [dateFormatter stringFromDate:self.data.remindDate];
        self.textLabel.frame = CGRectMake(PaddingLeft, 4.0f, UI_SCREEN_WIDTH - PaddingLeft, 21.0f);
        _remindTxt.text = [dateFormatter stringFromDate:self.data.remindDate];
        _remindTxt.hidden = NO;
        _remindClockImgView.hidden = NO;
    }else{
//        self.detailTextLabel.text = @"";
        self.textLabel.frame = CGRectMake(PaddingLeft, 12.0f, UI_SCREEN_WIDTH - PaddingLeft, 21.0f);
        _remindTxt.hidden = YES;
        _remindClockImgView.hidden = YES;
    }
//    _remindClockImgView.hidden = YES;
//    if(![GanStringUtil isBlank:self.detailTextLabel.text]){
//        CGRect detailTextLabelFrame = self.detailTextLabel.frame;
//        CGRect remindClockImgViewFrame = _remindClockImgView.frame;
//        remindClockImgViewFrame.origin = detailTextLabelFrame.origin;
//        _remindClockImgView.frame = remindClockImgViewFrame;
//        
//        detailTextLabelFrame.origin.x = 100.0f;
//        self.detailTextLabel.frame = detailTextLabelFrame;
//        _remindClockImgView.hidden = NO;
//    }
    
//    [self setNeedsDisplay];
//    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if(![GanStringUtil isBlank:_remindTxt.text]){
        self.textLabel.frame = CGRectMake(PaddingLeft, 4.0f, UI_SCREEN_WIDTH - PaddingLeft, 21.0f);
    }else{
        self.textLabel.frame = CGRectMake(PaddingLeft, 12.0f, UI_SCREEN_WIDTH - PaddingLeft, 21.0f);
    }
}

#pragma mark - public
- (void)setDataValToTxt{
    self.textLabel.text = self.data.content;
    _contentEditTxt.text = self.data.content;
}

- (void)setRemindDate:(NSDate *)date{
    self.data.remindDate = date;
    [self changeStateForRemindDate];
}
@end

