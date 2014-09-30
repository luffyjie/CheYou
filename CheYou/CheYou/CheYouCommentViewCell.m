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
#import "UIImageView+MJWebCache.h"

#define IMAGE_HEIGHT_SIZE   34.f
#define IMAGE_WIDTH_SIZE    34.f
#define NAME_DISTANCE_WIDTH  100.f
#define TAG_DISTANCE_WIDTH  100.f

@implementation CheYouCommentViewCell

{
    UIImageView *userImage;
    UILabel *screen_name;
    UILabel *created_at;
    UILabel *pingLunText;
}

@synthesize pinglun = _pinglun;

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
        
        pingLunText = [[UILabel alloc] init];
        pingLunText.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview: pingLunText];
        
        //add by lujie for debug
        //        userImage.backgroundColor = [UIColor lightGrayColor];
        //        screen_name.backgroundColor = [UIColor blueColor];
        //        created_at.backgroundColor = [UIColor yellowColor];
        //        pingLunText.backgroundColor = [UIColor greenColor];
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
    [userImage.layer setCornerRadius:CGRectGetHeight([userImage bounds]) / 2];
    userImage.layer.masksToBounds = YES;
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

-(void)setPinglun:(PingLun *)pinglun
{
    if (_pinglun != pinglun) {
        _pinglun = pinglun;
        // 下载图片
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
        if (!_pinglun.hpic) {
            _pinglun.hpic = @"/2014/9/1411953899.png";
        }
        [userImage setImageURLStr: [@"http://cheyoulianmeng.b0.upaiyun.com" stringByAppendingString: _pinglun.hpic] placeholder:placeholder];
        screen_name.text = _pinglun.nkname;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_pinglun.createtime doubleValue]/1000];
        created_at.text = [formatter stringFromDate: confromTimesp];
        pingLunText.text = _pinglun.content;
        [self makeContentFrame];
    }
}

-(void)makeContentFrame
{
    //获得当前cell高度
    CGRect frame = [self frame];
    //设置label的最大行数
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    pingLunText.numberOfLines = 0;
    CGSize size = CGSizeMake(frame.size.width - 55.f - 15.f, 1000);
    CGSize textSize = [pingLunText.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    pingLunText.frame = CGRectMake(60.f, 61.f, textSize.width, textSize.height);
    //计算出cell自适应的高度
    frame.size.height = textSize.height + 70.f;
    self.frame = frame;
    self.contentView.frame = frame;
}

@end

