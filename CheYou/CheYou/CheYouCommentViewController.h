//
//  CheYouCommentViewController.h
//  CheYou
//
//  Created by lujie on 14-9-10.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuCao.h"
#import "CheYouTuCaoTableViewCell.h"

@interface CheYouCommentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) TuCao *tucao;
@property (nonatomic, strong) NSIndexPath *indexpath;

@end
