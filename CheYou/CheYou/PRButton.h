//
//  PRButton.h
//  CheYou
//
//  Created by lujie on 14-9-5.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRButton : UIButton
@property (strong, nonatomic, readwrite) UIView *inputView;
@property (strong, nonatomic, readwrite) UIView *inputAccessoryView;
@end
