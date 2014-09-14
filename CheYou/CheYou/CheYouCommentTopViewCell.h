//
//  CheYouCommentTopViewCell.h
//  CheYou
//
//  Created by lujie on 14-9-14.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuCao.h"

@interface CheYouCommentTopViewCell : UITableViewCell
@property (nonatomic, strong) TuCao *tucao;
@property (nonatomic, strong) UIView *userPhotoView;
@property (nonatomic, strong) UILabel *tuCaoText;

@end
