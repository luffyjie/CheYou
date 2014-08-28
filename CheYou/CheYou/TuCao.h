//
//  TuCao.h
//  CheYou
//
//  Created by lujie on 14-8-28.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuCao : NSObject
@property (nonatomic, assign) NSInteger *tu_id;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *tuCaotext;
@property (nonatomic, copy) NSString *tuCaotag;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSArray *pic_urls;

@end
