//
//  GanTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-6-16.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanTableViewCell.h"
#import "GanViewController.h"
#import "GanTableViewCellDelegate.h"
//@interface GanTableViewCell (){
//    CGPoint tempPanGesturesPoint;
//}
//@end
@class MCSwipeTableViewCell;
@implementation GanTableViewCell
-(void)prepareForReuse{
    NSLog(@"GanTableViewCell prepareForReuse...");
}


-(NSString *)reuseIdentifier{
    //    NSLog(@"reuseIdentifier...");
    return @"GanTableViewCellIdentifier";
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
    NSLog(@"GanTableViewCell initWithSytle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCustomElements];
    }
    return self;
}

-(void)initCustomElements{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [self addDoubleClickEvnet];
    
//    [self addSwipeEvent];
    self.textLabel.hidden = YES;
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.frame = CGRectMake(0,0, 320, 44);
    self.contentLabel.shadowColor = [[UIColor alloc]initWithRed:0xcc/255.f green:0xcc/255.f blue:0xcc/255.f alpha:1];
    self.contentLabel.shadowOffset = CGSizeMake(2, 1);
    [self.contentView addSubview:self.contentLabel];
    
    self.contentEditTxt = [[UITextField alloc]init];
    self.contentEditTxt.frame = CGRectMake(0,0, 320, 44);
    self.contentEditTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentEditTxt.returnKeyType = UIReturnKeyDone;
    
    [self.contentEditTxt addTarget:self action:@selector(keyboardDoneClcik:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.contentView addSubview:self.contentEditTxt];
    
}

-(void)keyboardDoneClcik:(id)sender{
    [self hideKeyboard:self];
    [self setDataContent:self.contentEditTxt.text];
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
    NSLog(@"doubleLick");
    self.contentEditTxt.text = self.contentLabel.text;
    [self beginEdit];
}

-(void)beginEdit{
    self.contentEditTxt.hidden = NO;
    self.contentLabel.hidden = YES;
    [self.contentEditTxt becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSLog(@"setSelected %i    %i    %@",selected,![self.contentEditTxt.text isEqualToString: @""],self.contentEditTxt.text);
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    self.contentEditTxt.hidden = YES;
    self.contentLabel.hidden = NO;
    //cell失去焦点，保存编辑数据
    if(selected == NO){
        self.contentLabel.text = self.contentEditTxt.text;
        [self setDataContent:self.contentEditTxt.text];
    }else{
        //新增行，自动进入编辑模式
        if([self.data.content isEqualToString:@""]){
            [self beginEdit];
        }
    }
}

-(void)setDataContent:(NSString *)content{
    if(!self.data.isNew && [content isEqualToString:@""]){
        [self.delegate deleteCell:self.data];
    }
    self.data.content = content;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    //    NSLog(@"willMoveToSuperview");
    [super willMoveToSuperview:newSuperview];
    self.contentLabel.text = _data.content;
    self.contentEditTxt.text = _data.content;
}

@end
