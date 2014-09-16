//
//  CheYouDianzanViewCell.m
//  CheYou
//
//  Created by lujie on 14-9-16.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouDianzanViewCell.h"
#import "LuJieCommon.h"
#import "UIImageExt.h"

#define IMAGE_HEIGHT_SIZE   24.f
#define IMAGE_WIDTH_SIZE    24.f
#define NAME_DISTANCE_WIDTH  100.f
#define TAG_DISTANCE_WIDTH  100.f

@implementation CheYouDianzanViewCell
{
    UIImageView *userImage;
    UILabel *screen_name;
    UILabel *created_at;
    UILabel *midLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        userImage = [[UIImageView alloc] init];
        [self.contentView addSubview: userImage];
        
        screen_name = [[UILabel alloc] init];
        screen_name.font = [UIFont boldSystemFontOfSize:14.f];
        [self.contentView addSubview: screen_name];
        
        created_at = [[UILabel alloc] init];
        created_at.font = [UIFont boldSystemFontOfSize:10.f];
        created_at.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview: created_at];
        
        midLine = [[UILabel alloc] init];
        midLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xD7D7D7];
        [self.contentView addSubview: midLine];
        
        //add by lujie for debug
//        userImage.backgroundColor = [UIColor lightGrayColor];
//        screen_name.backgroundColor = [UIColor blueColor];
//        created_at.backgroundColor = [UIColor yellowColor];
//
//        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (CGRect)userImageFrame {
    
    return CGRectMake( 12.f, 12.f, IMAGE_WIDTH_SIZE, IMAGE_HEIGHT_SIZE);
}

- (CGRect)screen_nameFrame {
    
    return CGRectMake(IMAGE_WIDTH_SIZE + 12.f + 15.f, 15.f, NAME_DISTANCE_WIDTH, 20.f);
}

- (CGRect)created_atFrame {
    
    return CGRectMake(self.contentView.frame.size.width - 120.f, 23.f, 100.f, 12.f);
}

- (CGRect)midLineFrame {
    
    return CGRectMake(0, self.contentView.frame.size.height - 1.f, self.contentView.frame.size.width, 1.0f);;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [userImage setFrame:[self userImageFrame]];
    [screen_name setFrame:[self screen_nameFrame]];
    [created_at setFrame:[self created_atFrame]];
    [midLine setFrame:[self midLineFrame]];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setTucao:(TuCao *)tucao
{
    if (_tucao != tucao) {
        _tucao = tucao;
        userImage.image = [UIImage imageNamed:_tucao.profile_image_url];
        screen_name.text = _tucao.screen_name;
        created_at.text = _tucao.created_at;
    }
}

@end
