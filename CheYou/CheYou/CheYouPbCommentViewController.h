//
//  CheYouPbCommentViewController.h
//  CheYou
//
//  Created by lujie on 14-9-15.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PingLun;

//声明一个表示已经发送了评论代理
@protocol PbCommentDelegate <NSObject>
-(void)pbComment:(PingLun *)pinglun;

@end

@interface CheYouPbCommentViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) NSString *lbid;
// 代理
@property(nonatomic,assign) NSObject<PbCommentDelegate> *delegate;

@end
