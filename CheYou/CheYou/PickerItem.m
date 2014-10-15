//
//  PickerItem.m
//  CheYou
//
//  Created by lujie on 14-10-15.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "PickerItem.h"

@implementation PickerItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithimage:(NSInteger)imgid toimg: (UIImage *)img frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imgid = imgid;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 92, 92)];
        [self addSubview:_imageView];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setImage:img];
        
        UIImage *deleteBtnBgImage = [UIImage imageNamed:@"choose_photo_delete"];
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = (CGRect){2, 2, deleteBtnBgImage.size};
        [self.deleteBtn setImage:deleteBtnBgImage forState:UIControlStateNormal];
        [self addSubview:self.deleteBtn];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBtnDidClick:)]];
    }
    return self;
}

#pragma mark 

- (void)deleteBtnDidClick:(id)sender
{
    //向通知中心发送消息
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"deletePhotoNotification"
     object:nil
     userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",_imgid] forKey:@"imgid"]];
}

@end
