//
//  CheYouTuCaoTableViewCell.h
//  CheYou
//
//  Created by lujie on 14-8-28.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuCao.h"

@interface CheYouTuCaoTableViewCell : UITableViewCell
@property (nonatomic, strong) TuCao *tucao;
@property (nonatomic, strong) UIView *userPhotoView;
@property (nonatomic, strong) UILabel *tuCaoText;
@property (nonatomic, strong) UILabel *gasolineLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *gasolineView;

@end
