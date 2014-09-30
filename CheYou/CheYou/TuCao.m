//
//  TuCao.m
//  CheYou
//
//  Created by lujie on 14-8-28.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "TuCao.h"

@implementation TuCao
/*
 Initialize a TuCao object.
 */
- (id)init {
    self = [super init];
    if (self) {
        _commentList = [[NSMutableArray alloc] init];
        _jyouList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setCommentList:(NSMutableArray*) array{
    if(_commentList != nil)
    {
        _commentList = nil;
    }
    _commentList = [array mutableCopy];
}

-(void)setJyouList :(NSMutableArray*) array{
    if(_jyouList  != nil)
    {
        _jyouList = nil;
    }
    _jyouList = [array mutableCopy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@-%@-%@-%@--%@-%@-%@",_lbid,_account,_nkname,_hpic,_huati,_imgList,_jyouList,_commentList,_createtime,_updatetime,_type,_location,_huati];
}

@end
