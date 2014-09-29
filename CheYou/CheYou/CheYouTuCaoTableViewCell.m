//
//  CheYouTuCaoTableViewCell.m
//  CheYou
//
//  Created by lujie on 14-8-28.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouTuCaoTableViewCell.h"
#import "LuJieCommon.h"
#import "UIImageExt.h"
#import "UIImageView+MJWebCache.h"

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
    UIView *userPhotoView;
    UIImageView *commentView;
}

@synthesize userPhotoView = userPhotoView;
@synthesize tuCaoText = tuCaoText;
@synthesize tucao = _tucao;
@synthesize gasolineLabel = gasolineLabel;
@synthesize commentLabel = commentLabel;
@synthesize gasolineView = gasolineView;

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
        
        tuCaoTag = [[UILabel alloc] init];
        tuCaoTag.textAlignment = NSTextAlignmentRight;
        tuCaoTag.font = [UIFont boldSystemFontOfSize:14.f];
        tuCaoTag.textColor = [LuJieCommon UIColorFromRGB:0x3498db];
//        [self.contentView addSubview: tuCaoTag];
        
        created_at = [[UILabel alloc] init];
        created_at.font = [UIFont boldSystemFontOfSize:10.f];
        [self.contentView addSubview: created_at];
        
        tuCaoText = [[UILabel alloc] init];
        tuCaoText.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview: tuCaoText];
        
        userPhotoView = [[UIView alloc] init];
        [self.contentView addSubview: userPhotoView];
        
        midLine = [[UILabel alloc] init];
        midLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xD7D7D7];
        [self.contentView addSubview: midLine];
        
        footLine = [[UILabel alloc] init];
        footLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
        [self.contentView addSubview: footLine];
        

        gasolineLabel = [[UILabel alloc] init];
        gasolineLabel.text = @"0";
        gasolineLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:gasolineLabel];
        
        commentLabel = [[UILabel alloc] init];
        commentLabel.text = @"0";
        commentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:commentLabel];
        
        gasolineView = [[UIImageView alloc] init];
        gasolineView.image = [UIImage imageNamed:@"tc_gasoline_unselect"];
        [self.contentView addSubview:gasolineView];
        
        commentView = [[UIImageView alloc] init];
        commentView.image = [UIImage imageNamed:@"tc_comment"];
        [self.contentView addSubview:commentView];
        
        //add by lujie for debug
//        userImage.backgroundColor = [UIColor lightGrayColor];
//        screen_name.backgroundColor = [UIColor blueColor];
//        created_at.backgroundColor = [UIColor yellowColor];
//        tuCaoTag.backgroundColor = [UIColor redColor];
//        tuCaoText.backgroundColor = [UIColor greenColor];
//        userPhotoView.backgroundColor = [UIColor redColor];
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

- (CGRect)tuCaoTagFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - 12.f - TAG_DISTANCE_WIDTH, 15.f, TAG_DISTANCE_WIDTH, 20.f);
}

- (CGRect)created_atFrame {
    
    return CGRectMake(IMAGE_WIDTH_SIZE + 12.f + 15.f, 38.f, 100.f, 12.f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [userImage setFrame:[self userImageFrame]];
    [userImage.layer setCornerRadius:CGRectGetHeight([userImage bounds]) / 2];
    userImage.layer.masksToBounds = YES;
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
//        userImage.image = [UIImage imageNamed:_tucao.profile_image_url];
        // 下载图片
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
        [userImage setImageURLStr: [@"http://cheyoulianmeng.b0.upaiyun.com" stringByAppendingString: _tucao.profile_image_url] placeholder:placeholder];
        screen_name.text = _tucao.screen_name;
        created_at.text = @"123";//_tucao.created_at;
        tuCaoTag.text = [NSString stringWithFormat:@"#%@", _tucao.tuCaotag];
        tuCaoText.text = _tucao.tuCaotext;
        gasolineLabel.text = _tucao.tu_id;
        commentLabel.text = _tucao.tu_id;
        [self makeContentFrame];
    }
}

-(void)makeContentFrame
{
    //获得当前cell高度
    CGRect frame = [self frame];
    //设置label的最大行数
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    tuCaoText.numberOfLines = 0;
    CGSize size = CGSizeMake(frame.size.width - 12.f - 12.f, 1000);
//    CGSize textSize = [tuCaoText.text sizeWithFont:tuCaoText.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize = [tuCaoText.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    tuCaoText.frame = CGRectMake(12.f, 61.f, textSize.width, textSize.height);
    //设置图片的位置和大小
    if (_tucao.pic_urls.count > 0) {
        if (_tucao.pic_urls.count ==1) {
            userPhotoView.frame =  CGRectMake(0, textSize.height + 70.f, self.contentView.bounds.size.width,100);
        }else{
            userPhotoView.frame = _tucao.pic_urls.count > 3 ? CGRectMake(0, textSize.height + 70.f, self.contentView.bounds.size.width, 170)
            : CGRectMake(0, textSize.height + 70.f, self.contentView.bounds.size.width, 80);
        }
    }
    //计算出cell自适应的高度
    frame.size.height = textSize.height + userPhotoView.bounds.size.height + 113.f;
    self.frame = frame;
    self.contentView.frame = frame;
    //最后设置foot+mid 间隔框的位置
    footLine.frame = CGRectMake(0, frame.size.height - 5.f, frame.size.width, 5.f);
    midLine.frame = CGRectMake(0, frame.size.height - 34.f, frame.size.width, 1.0f);
    //设置评论计数位置
    gasolineLabel.frame = CGRectMake(frame.size.width - 52.f, frame.size.height - 29.f, 40.f, 20.f);
    commentLabel.frame = CGRectMake(frame.size.width/2 - 2, frame.size.height - 29.f, 40.f, 20.f);
    gasolineView.frame = CGRectMake(frame.size.width - 80.f, frame.size.height - 26.f, 15.f, 15.f);
    commentView.frame = CGRectMake(frame.size.width/2 - 30, frame.size.height - 25.f, 15.f, 15.f);
}

@end
