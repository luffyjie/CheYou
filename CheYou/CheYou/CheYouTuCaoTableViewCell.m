//
//  CheYouTuCaoTableViewCell.m
//  CheYou
//
//  Created by lujie on 14-8-28.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouTuCaoTableViewCell.h"
#import "LuJieCommon.h"

#define IMAGE_HEIGHT_SIZE   34.f
#define IMAGE_WIDTH_SIZE    34.f
#define NAME_DISTANCE_WIDTH  100.f
#define TAG_DISTANCE_WIDTH  100.f

@implementation CheYouTuCaoTableViewCell
{
    UIImageView *userImage;
    UILabel *screen_name;
    UILabel *created_at;
    UILabel *tuCaoTag;
    UILabel *tuCaoText;
    UILabel *midLine;
    UILabel *footLine;
}


@synthesize tucao = _tucao;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview: userImage];
        
        screen_name = [[UILabel alloc] initWithFrame:CGRectZero];
        screen_name.font = [UIFont boldSystemFontOfSize:14.f];
        [self.contentView addSubview: screen_name];
        
        tuCaoTag = [[UILabel alloc] initWithFrame:CGRectZero];
        tuCaoTag.textAlignment = NSTextAlignmentRight;
        tuCaoTag.font = [UIFont boldSystemFontOfSize:14.f];
        tuCaoTag.textColor = [LuJieCommon UIColorFromRGB:0x3498db];
        [self.contentView addSubview: tuCaoTag];
        
        created_at = [[UILabel alloc] initWithFrame:CGRectZero];
        created_at.font = [UIFont boldSystemFontOfSize:10.f];
        [self.contentView addSubview: created_at];
        
        tuCaoText = [[UILabel alloc] initWithFrame:CGRectZero];
        tuCaoText.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview: tuCaoText];
        
        midLine = [[UILabel alloc] initWithFrame:CGRectZero];
        midLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xD7D7D7];
        [self.contentView addSubview: midLine];
        
        footLine = [[UILabel alloc] initWithFrame:CGRectZero];
        footLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xD7D7D7];
        [self.contentView addSubview: footLine];
        
        //add by lujie for debug
//        userImage.backgroundColor = [UIColor lightGrayColor];
//        screen_name.backgroundColor = [UIColor blueColor];
//        created_at.backgroundColor = [UIColor yellowColor];
//        tuCaoTag.backgroundColor = [UIColor redColor];
//        tuCaoText.backgroundColor = [UIColor greenColor];

    }
    return self;
}

- (CGRect)userImageFrame {

    return CGRectMake( 12.f, 12.f, IMAGE_WIDTH_SIZE, IMAGE_HEIGHT_SIZE);
}

- (CGRect)screen_nameFrame {
    
    return CGRectMake(IMAGE_WIDTH_SIZE + 12.f + 15.f, 15.f, NAME_DISTANCE_WIDTH, 20.f);
}

- (CGRect)tuCaoTagFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - 12.f - TAG_DISTANCE_WIDTH, 15.f, TAG_DISTANCE_WIDTH, 20.f);
}

- (CGRect)created_atFrame {
    
    return CGRectMake(IMAGE_WIDTH_SIZE + 12.f + 15.f, 35.f, 100.f, 12.f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [userImage setFrame:[self userImageFrame]];
    [screen_name setFrame:[self screen_nameFrame]];
    [tuCaoTag setFrame:[self tuCaoTagFrame]];
    [created_at setFrame:[self created_atFrame]];

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
        tuCaoTag.text = [NSString stringWithFormat:@"#%@", _tucao.tuCaotag];
        tuCaoText.text = _tucao.tuCaotext;
        [self makeContentFrame];
    }
}

-(void)makeContentFrame
{
    //获得当前cell高度
    CGRect frame = [self frame];
    //设置label的最大行数
    tuCaoText.numberOfLines = 0;
    CGSize size = CGSizeMake(frame.size.width - 12.f - 12.f, 1000);
    CGSize labelSize = [tuCaoText.text sizeWithFont:tuCaoText.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    tuCaoText.frame = CGRectMake(12.f, 61.f, labelSize.width, labelSize.height);
    //计算出自适应的高度
    frame.size.height = labelSize.height+123.f;
    self.frame = frame;
    //最后设置foot+mid 间隔框的位置
    footLine.frame = CGRectMake(0, frame.size.height - 10.f, frame.size.width, 10.f);
    midLine.frame = CGRectMake(0, frame.size.height - 50.f, frame.size.width, 1.f);
}

@end
