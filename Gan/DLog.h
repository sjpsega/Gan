//
//  DLog.h
//  Gan
//
//  Created by sjpsega on 13-7-22.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#ifndef Gan_DLog_h
#define Gan_DLog_h

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#endif
