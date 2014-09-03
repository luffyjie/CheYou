//
//  UIImageExt.h
//  CheYou
//
//  Created by lujie on 14-9-3.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (UIImageExt)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)getSubImage:(CGRect)rect;
- (UIImage*)scaleToSize:(CGSize)size;

@end
