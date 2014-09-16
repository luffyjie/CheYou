//
//  CheYouCommentViewCell.m
//  CheYou
//
//  Created by lujie on 14-9-11.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouCommentViewCell.h"
#import "LuJieCommon.h"
#import "UIImageExt.h"

#define IMAGE_HEIGHT_SIZE   34.f
#define IMAGE_WIDTH_SIZE    34.f
#define NAME_DISTANCE_WIDTH  100.f
#define TAG_DISTANCE_WIDTH  100.f

@implementation CheYouCommentViewCell

{
    UIImageView *userImage;
    UILabel *screen_name;
    UILabel *created_at;
    UILabel *tuCaoText;
}

@synthesize tucao = _tucao;

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
        [self.contentView addSubview: created_at];
        
        tuCaoText = [[UILabel alloc] init];
        tuCaoText.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview: tuCaoText];
        
        //add by lujie for debug
        //        userImage.backgroundColor = [UIColor lightGrayColor];
        //        screen_name.backgroundColor = [UIColor blueColor];
        //        created_at.backgroundColor = [UIColor yellowColor];
        //        tuCaoText.backgroundColor = [UIColor greenColor];
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
    
    return CGRectMake(IMAGE_WIDTH_SIZE + 12.f + 15.f, 38.f, 100.f, 12.f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [userImage setFrame:[self userImageFrame]];
    [screen_name setFrame:[self screen_nameFrame]];
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
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.firstLineHeadIndent = 50.f;
        paragraphStyle.headIndent = 50.f;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14],
                                      NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor blackColor]};
        tuCaoText.attributedText = [[NSAttributedString alloc]initWithString: _tucao.tuCaotext attributes:attributes];
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
    CGSize textSize = [tuCaoText.text sizeWithFont:tuCaoText.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    tuCaoText.frame = CGRectMake(12.f, 61.f, textSize.width, textSize.height);
    //计算出cell自适应的高度
    frame.size.height = textSize.height + 70.f;
    self.frame = frame;
    self.contentView.frame = frame;
}

@end

