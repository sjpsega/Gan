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

@implementation GanUnComplateTableViewCell

+(NSString *)getReuseIdentifier{
    return ReuseIdentifier.copy;
}

-(void)prepareForReuse{
    DLog(@"GanTableViewCell prepareForReuse...");
}


-(NSString *)reuseIdentifier{
    //    NSLog(@"reuseIdentifier...");
    return ReuseIdentifier.copy;
}

//-(void)awakeFromNib{
//    NSLog(@"gan awakeFromNib...");
//    
//    [super awakeFromNib];
//    [self initCustomElements];
//}

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
    }
    return self;
}

-(void)viewDidLoad{

}

-(void)initCustomElements{
    
    [self addDoubleClickEvnet];
    
//    [self addSwipeEvent];
//    self.textLabel.hidden = YES;
    
//    self.contentLabel = [[UILabel alloc]init];
//    self.contentLabel.frame = CGRectMake(0,0, 320, 44);
//    self.contentLabel.shadowColor = [[UIColor alloc]initWithRed:0xcc/255.f green:0xcc/255.f blue:0xcc/255.f alpha:1];
//    self.contentLabel.shadowOffset = CGSizeMake(2, 1);
//    [self.contentView addSubview:self.contentLabel];
    
    self.contentEditTxt = [[UITextField alloc]init];
    self.contentEditTxt.frame = CGRectMake(0,0, 320, 44);
    self.contentEditTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentEditTxt.returnKeyType = UIReturnKeyDone;
    
    [self.contentEditTxt addTarget:self action:@selector(keyboardDoneClcik:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.contentView addSubview:self.contentEditTxt];
    
}

-(void)clearColorWithElement{
//    UIColor *bgColor;
//    bgColor = [UIColor colorWithRed:0xf6/255.f green:0xf6/255.f blue:0x34/255.f alpha:1.f];
//    self.backgroundColor = bgColor;
    for ( UIView* view in self.contentView.subviews )
    {
        view.backgroundColor = [UIColor clearColor];
    }
}

-(void)keyboardDoneClcik:(id)sender{
    [self hideKeyboard:self];
    [self setDataContent:self.contentEditTxt.text];
    if([self.delegate respondsToSelector:@selector(blurCell:)]){
        [self.delegate blurCell];
    }
}

-(IBAction)hideKeyboard:(id)sender{
    [self.contentEditTxt resignFirstResponder];
}

-(void)addDoubleClickEvnet{
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editHandler:)];
    doubleClick.numberOfTapsRequired = 2;
    doubleClick.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleClick];
}

-(void)editHandler:(UIGestureRecognizer *)recognizer{
    DLog(@"doubleLick");
//    self.contentEditTxt.text = self.contentLabel.text;
    self.contentEditTxt.text = self.textLabel.text;
    [self beginEdit];
}

-(void)beginEdit{
    self.contentEditTxt.hidden = NO;
    self.textLabel.hidden = YES;
    [self.contentEditTxt becomeFirstResponder];
    if([self.delegate respondsToSelector:@selector(focusCell:)]){
        [self.delegate focusCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    NSLog(@"setSelected %i    %i    %@",selected,![self.contentEditTxt.text isEqualToString: @""],self.contentEditTxt.text);
    [super setSelected:selected animated:NO];
    // Configure the view for the selected state
    
    self.contentEditTxt.hidden = YES;
    self.textLabel.hidden = NO;
    //cell失去焦点，保存编辑数据
    if(selected == NO){
        self.textLabel.text = self.contentEditTxt.text;
        [self setDataContent:self.contentEditTxt.text];
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
    self.contentEditTxt.text = _data.content;
}

@end
