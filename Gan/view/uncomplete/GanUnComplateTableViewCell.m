
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
#import "GanDateUtil.h"
#import "MobClick.h"

static const NSString *ReuseIdentifier = @"GanUnComplateTableViewCellIdentifier";
static const UIColor *FutureDateColor;
static const UIColor *OutOfDateColor;
static const CGFloat PaddingLeft = 15.0f;
static NSDateFormatter *dateFormatter;
static CGRect textLabelFrameWithNormal;
static CGRect textLabelFrameWithHaveDate;

@interface GanUnComplateTableViewCell()
@end

@implementation GanUnComplateTableViewCell{
    UIImageView *_editRemindImgView;
    //editRemindImg的作用范围View，扩大原本的作用范围
    UIView *_editRemindImgEffectView;
    //使用iconFont，高保真
    UILabel *_remindClockImg;
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
//        dateFormatter.dateStyle = kCFDateFormatterShortStyle;
//        dateFormatter.timeStyle = kCFDateFormatterShortStyle;
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        //参考资料：http://nshipster.com/nslocale/   http://my.oschina.net/yongbin45/blog/150667
        DLog(@"Locale: %@ -- %@ -- %@",[[NSLocale currentLocale] localeIdentifier],[[NSLocale systemLocale]localeIdentifier],[NSLocale preferredLanguages]);
        
        [dateFormatter setDateFormat:@"dd/MM HH:mm ccc"];
        
        NSString *localeIdentifierLowercase = [[[NSLocale currentLocale]localeIdentifier] lowercaseString];
        if([localeIdentifierLowercase rangeOfString:@"zh_cn"].location != NSNotFound || [localeIdentifierLowercase rangeOfString:@"zh_tw"].location != NSNotFound){
            [dateFormatter setDateFormat:@"MM-dd HH:mm ccc"];
        }
        
        FutureDateColor = [UIColor Gan_ColorWithHEX:0x318ad6 alpha:1.0f];
        OutOfDateColor = [UIColor Gan_ColorWithHEX:0xd42b2a alpha:1.0f];
        
        textLabelFrameWithNormal = CGRectMake(PaddingLeft, 12.0f, UI_SCREEN_WIDTH - PaddingLeft, 21.0f);
        textLabelFrameWithHaveDate = CGRectMake(PaddingLeft, 4.0f, UI_SCREEN_WIDTH - PaddingLeft, 21.0f);
    });
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isEditing = false;
        [self initCustomElements];
        [self addLine];
    }
    return self;
}

- (void)dealloc{
    [self clear];
}

- (void)clear{
    if(self.data){
        @try {
            [self.data removeObserver:self forKeyPath:@"remindDate"];
            [self.data removeObserver:self forKeyPath:@"isCompelete"];
        }
        @catch (NSException *exception) {
            DLog(@"exception:%@",exception);
        }
        @finally {
            
        }
        
    }
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
    
    [self addEditClockIcon];
    
    [self addClockIconSingleTapEvent];
    
    [self addRemindClockIcon];
    
    [self addRemindTxt];
}

#pragma mark addContentEditTxt
- (void)addContentEditTxt{
    _contentEditTxt = [[UITextField alloc]init];
    _contentEditTxt.frame = CGRectMake(PaddingLeft, 0, UI_SCREEN_WIDTH - PaddingLeft, GAN_CELL_HEIGHT);
    _contentEditTxt.font = [UIFont fontWithName:@"Arial" size:18.0];
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
        _editRemindImgView.hidden = YES;
        _editRemindImgEffectView.hidden = YES;
    }else{
        _editRemindImgView.hidden = NO;
        _editRemindImgEffectView.hidden = NO;
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
    //如果双击的位置是clockImg的位置，则不进行编辑
    CGPoint touchPoint = [recognizer locationInView:self];
    BOOL isTouchImgView = CGRectContainsPoint(_editRemindImgEffectView.frame, touchPoint);
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
        _contentEditTxt.frame = textLabelFrame;
    }
    _contentEditTxt.hidden = NO;
    self.textLabel.hidden = YES;
    _editRemindImgView.hidden = YES;
    _editRemindImgEffectView.hidden = YES;
    
    if(![GanStringUtil isBlank:_contentEditTxt.text]){
        _editRemindImgView.hidden = NO;
        _editRemindImgEffectView.hidden = NO;
    }
    [_contentEditTxt becomeFirstResponder];
    if([self.delegate respondsToSelector:@selector(focusCell)]){
        _isEditing = true;
        [self.delegate focusCell];
    }
}

#pragma mark addClockIcon
- (void)addEditClockIcon{
    UIImage *clockImg = [UIImage imageNamed:@"clock"];
    _editRemindImgView = [[UIImageView alloc]initWithImage:clockImg];
    CGRect frame = _editRemindImgView.frame;
    frame.origin = CGPointMake(UI_SCREEN_WIDTH - 30, (44 - CGRectGetHeight(frame))/2);
    _editRemindImgView.frame = frame;
    _editRemindImgView.hidden = YES;
    
    [self.contentView addSubview:_editRemindImgView];
    
    //扩大EditClockIcon的作用范围
    CGRect originRect = _editRemindImgView.frame;
    CGRect increaseRect = CGRectMake(CGRectGetMinX(originRect) - 7, CGRectGetMinY(originRect) - 7, CGRectGetWidth(originRect) + 14, CGRectGetHeight(originRect) + 14);
    _editRemindImgEffectView = [[UIView alloc]initWithFrame:increaseRect];
    _editRemindImgEffectView.hidden = YES;
    [self.contentView addSubview:_editRemindImgEffectView];
}

- (void)addClockIconSingleTapEvent{
    _editRemindImgEffectView.userInteractionEnabled = YES;
    UITapGestureRecognizer *clockTapGestureGecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editDateAction:)];
    clockTapGestureGecognizer.numberOfTapsRequired = 1;
    clockTapGestureGecognizer.numberOfTouchesRequired = 1;
    [_editRemindImgEffectView addGestureRecognizer:clockTapGestureGecognizer];
}

- (void)editDateAction:(id)sender{
    DLog(@"editDateAction");
    self.textLabel.text = _contentEditTxt.text;
    [self setDataContent:_contentEditTxt.text];
    _contentEditTxt.hidden = YES;
    self.textLabel.hidden = NO;
    [self hideKeyboard:self];
    
    [MobClick event:@"remind"];
    
    if([self.delegate respondsToSelector:@selector(showDatePickerView:)]){
        [self.delegate showDatePickerView:self.data.remindDate ? : [[NSDate alloc] initWithTimeInterval:60 sinceDate:[NSDate date]]];
    }
}

#pragma mark - addRemindClockIcon
- (void)addRemindClockIcon{
    CGFloat fontSize = 14.0f;
    _remindClockImg = [[UILabel alloc]initWithFrame:CGRectMake(PaddingLeft, 26.0f, fontSize, fontSize)];
    _remindClockImg.font = [UIFont fontWithName:@"icomoon" size:fontSize];
    _remindClockImg.text = @"\U0000e600";
    
    [self.contentView addSubview:_remindClockImg];
}

#pragma mark - addRemindTxt
- (void)addRemindTxt{
    _remindTxt = [[UILabel alloc]initWithFrame:CGRectMake(PaddingLeft + 20.0f, 25.0f, UI_SCREEN_WIDTH - PaddingLeft - 50.0f, 15.0f)];
    _remindTxt.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    [self.contentView addSubview:_remindTxt];
    _remindTxt.hidden = YES;
}

#pragma mark override setSelected:animated:
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    DLog(@"%i    %i    %@",selected,![_contentEditTxt.text isEqualToString: @""],_contentEditTxt.text);

    [super setSelected:selected animated:NO];

    //去除底色，否则默认是白色...
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    [self resetElementsHidden];
    
    if(selected){
        _editRemindImgView.hidden = NO;
        _editRemindImgEffectView.hidden = NO;
        //新增行，自动进入编辑模式
        if([self.data.content isEqualToString:@""]){
            [self beginEdit];
        }
    }else{
        //cell失去焦点，保存编辑数据
        self.textLabel.text = _contentEditTxt.text;
        [self setDataContent:_contentEditTxt.text];
        //清空_contentEditTxt数据，防止触发keyboardEnter，引起状态判断问题
//        _contentEditTxt.text = @"";
        [self hideKeyboard:self];
        [self resetElementsHidden];
    }
    [self changeStateForRemindDate];
}

- (void)resetElementsHidden{
    _contentEditTxt.hidden = YES;
    self.textLabel.hidden = NO;
    _editRemindImgView.hidden = YES;
    _editRemindImgEffectView.hidden = YES;
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
        DLog(@"%@ ---- %@",self.data.remindDate,[dateFormatter stringFromDate:self.data.remindDate]);
        self.textLabel.frame = CGRectMake(PaddingLeft, 4.0f, UI_SCREEN_WIDTH - PaddingLeft, 21.0f);
        _remindTxt.text = [dateFormatter stringFromDate:self.data.remindDate];
        NSString *dateString = [GanDateUtil compareDate:self.data.remindDate];
        if(dateString){
            NSString *timeString = [[dateFormatter stringFromDate:self.data.remindDate] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]][1];
            _remindTxt.text = [NSString stringWithFormat:@"%@ %@", dateString ,timeString];
        }
        _remindTxt.hidden = NO;
        _remindClockImg.hidden = NO;
        if([self.data.remindDate compare:[NSDate date]] == NSOrderedDescending){
            _remindTxt.textColor = [FutureDateColor copy];
            _remindClockImg.textColor = [FutureDateColor copy];
        }else{  
            _remindTxt.textColor = [OutOfDateColor copy];
            _remindClockImg.textColor = [OutOfDateColor copy];
        }
    }else{
        _remindTxt.text = @"";
        _remindTxt.hidden = YES;
        _remindClockImg.hidden = YES;
    }
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if([GanStringUtil isBlank:_remindTxt.text]){
        self.textLabel.frame = textLabelFrameWithNormal;
    }else{
        self.textLabel.frame = textLabelFrameWithHaveDate;
    }
}

#pragma mark - public
- (void)setDataValToTxt{
    self.textLabel.text = self.data.content;
    _contentEditTxt.text = self.data.content;
}

- (void)setRemindDate:(NSDate *)date{
    self.data.remindDate = date;
}

- (void)setData:(GanDataModel *)data{
    [self clear];
    [super setData:data];
    [self.data addObserver:self forKeyPath:@"remindDate" options:NSKeyValueObservingOptionNew context:(__bridge void *)(self)];
    [self.data addObserver:self forKeyPath:@"isCompelete" options:NSKeyValueObservingOptionNew context:(__bridge void *)(self)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == (__bridge void *)(self)) {
        [[GanLocalNotificationManager sharedInstance] cancelLocalNotify:self.data];
        if([keyPath isEqualToString:@"remindDate"]){
            [self changeStateForRemindDate];
            DLog(@"%@,%@,%d",self.data.remindDate,[NSDate date],[self.data.remindDate compare:[NSDate date]]);
            if([self.data.remindDate compare:[NSDate date]] == NSOrderedDescending){
                [[GanLocalNotificationManager sharedInstance] registeredLocalNotify:self.data];
            }
        }
        //空实现，只需要取消本地提醒即可
        if([keyPath isEqualToString:@"isComplete"]){
            
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end

