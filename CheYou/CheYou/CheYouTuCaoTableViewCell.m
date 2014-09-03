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
    UIView *userPhotoView;
    UILabel *midLine;
    UILabel *footLine;
    UIButton *commentbutton;
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
        
        tuCaoTag = [[UILabel alloc] init];
        tuCaoTag.textAlignment = NSTextAlignmentRight;
        tuCaoTag.font = [UIFont boldSystemFontOfSize:14.f];
        tuCaoTag.textColor = [LuJieCommon UIColorFromRGB:0x3498db];
        [self.contentView addSubview: tuCaoTag];
        
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
        footLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xD7D7D7];
        [self.contentView addSubview: footLine];
        
        
        commentbutton = [[UIButton alloc] init];
        
        //add by lujie for debug
//        userImage.backgroundColor = [UIColor lightGrayColor];
//        screen_name.backgroundColor = [UIColor blueColor];
//        created_at.backgroundColor = [UIColor yellowColor];
//        tuCaoTag.backgroundColor = [UIColor redColor];
//        tuCaoText.backgroundColor = [UIColor greenColor];
//        userPhotoView.backgroundColor = [UIColor purpleColor];
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
    CGSize textSize = [tuCaoText.text sizeWithFont:tuCaoText.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    tuCaoText.frame = CGRectMake(12.f, 61.f, textSize.width, textSize.height);
    //添加图片到内容下方
    if (_tucao.pic_urls.count > 0) {
        
        if (_tucao.pic_urls.count == 1) {
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, 150, 100)];
            userPhotoView.frame = CGRectMake(0, textSize.height + 70.f, self.contentView.bounds.size.width, 100);
            UIImage *image = [UIImage imageNamed: [_tucao.pic_urls objectAtIndex:0]];
            photo.image = image;
            [userPhotoView addSubview: photo];
        }
        
        if (_tucao.pic_urls.count >1 && _tucao.pic_urls.count < 4) {
            userPhotoView.frame = CGRectMake(0, textSize.height + 70.f, self.contentView.bounds.size.width, 80);
            for (int idx = 0; idx < _tucao.pic_urls.count; idx++) {
                UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80, 80, 80)];
                photo.image = [UIImage imageNamed: [_tucao.pic_urls objectAtIndex:idx]];
                [userPhotoView addSubview: photo];
            }
        }
        
        if(_tucao.pic_urls.count > 3)
        {
            userPhotoView.frame = CGRectMake(0, textSize.height + 70.f, self.contentView.bounds.size.width, 170);
            for (int idx = 0; idx < _tucao.pic_urls.count; idx++) {
                UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80+(idx/3)*5, 80, 80)];
                photo.image = [UIImage imageNamed: [_tucao.pic_urls objectAtIndex:idx]];
                [userPhotoView addSubview: photo];
            }
        }
    }
//    NSLog(@"%f",userPhotoView.bounds.size.height);
    //计算出cell自适应的高度
    frame.size.height = textSize.height + userPhotoView.bounds.size.height + 123.f;
    self.frame = frame;
    //最后设置foot+mid 间隔框的位置
    footLine.frame = CGRectMake(0, frame.size.height - 10.f, frame.size.width, 10.f);
    midLine.frame = CGRectMake(0, frame.size.height - 50.f, frame.size.width, 1.f);
}

-(void)makeUserPhoto
{
    if (_tucao.pic_urls.count > 0) {
        if (_tucao.pic_urls.count < 4) {
            userPhotoView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 60);
            for (int idx = 0; idx < _tucao.pic_urls.count; idx++) {
                UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*60+(idx%3+1)*10, (idx/3)*62, 60, 60)];
                photo.image = [UIImage imageNamed: [_tucao.pic_urls objectAtIndex:idx]];
                [userPhotoView addSubview: photo];
//                NSLog(@"%@",[_tucao.pic_urls objectAtIndex:idx]);
            }
        }else{
            userPhotoView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 130);
            for (int idx = 0; idx < _tucao.pic_urls.count; idx++) {
                UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*60+(idx%3+1)*10, (idx/3)*62, 60, 60)];
                photo.image = [UIImage imageNamed: [_tucao.pic_urls objectAtIndex:idx]];
                [userPhotoView addSubview: photo];
            }
        }
    }
    
}

@end
