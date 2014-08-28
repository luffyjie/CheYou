//
//  LuJieCommon.m
//  CheYou
//
//  Created by lujie on 14-8-27.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "LuJieCommon.h"

@implementation LuJieCommon

+ (UIColor *)UIColorFromRGB:(int)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@end
