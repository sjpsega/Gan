//
//  Global_ENUM.h
//  Gan
//
//  Created by sjpsega on 13-7-10.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#ifndef Gan_Global_ENUM_h
#define Gan_Global_ENUM_h

typedef NS_ENUM(NSUInteger, MCSwipeTableViewCellState){
    MCSwipeTableViewCellStateNone = 0,
    MCSwipeTableViewCellState1,
    MCSwipeTableViewCellState2,
    MCSwipeTableViewCellState3,
    MCSwipeTableViewCellState4
};

typedef NS_ENUM(NSUInteger, MCSwipeTableViewCellDirection){
    MCSwipeTableViewCellDirectionLeft = 0,
    MCSwipeTableViewCellDirectionCenter,
    MCSwipeTableViewCellDirectionRight
};

typedef NS_ENUM(NSUInteger, MCSwipeTableViewCellMode){
    MCSwipeTableViewCellModeExit = 0,
    MCSwipeTableViewCellModeSwitch
};

#define TITLE_TINY 0x00BF96
#define CELL_BG 0xF7E967
#define CELL_EDIT_BG 0xFFB03B
#define COMPLATE_COLOR 0x328F26
#define UNCOMPLATE_COLOR 0xA9CF54
#define DEL_COLOR 0xE83D0E
#define TABLE_BG 0xCAFCD8
#endif
