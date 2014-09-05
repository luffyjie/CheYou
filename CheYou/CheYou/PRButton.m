//
//  PRButton.m
//  CheYou
//
//  Created by lujie on 14-9-5.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "PRButton.h"

@implementation PRButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

# pragma mark - UIResponder overrides

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
}

@end
