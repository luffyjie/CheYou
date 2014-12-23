//
//  TuCao.h
//  CheYou
//
//  Created by lujie on 14-8-28.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuCao : NSObject
@property (nonatomic, copy) NSString *lbid;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *nkname;
@property (nonatomic, copy) NSString *hpic;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dccase;
@property (nonatomic, copy) NSString *jgtime;
@property (nonatomic, copy) NSString *tttime;
@property (nonatomic, copy) NSString *huati;
@property (nonatomic, assign) int jyou;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSArray *imgList;
@property (nonatomic, copy) NSMutableArray *commentList;
@property (nonatomic, copy) NSMutableArray *jyouList;

@end
