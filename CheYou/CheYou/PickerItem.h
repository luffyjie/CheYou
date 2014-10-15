//
//  PickerItem.h
//  CheYou
//
//  Created by lujie on 14-10-15.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PickerItem : UIView
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign) NSInteger imgid;

- (id)initWithimage:(NSInteger)imgid toimg: (UIImage *)img frame:(CGRect)frame;

@end
