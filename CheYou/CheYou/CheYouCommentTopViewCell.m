//
//  CheYouCommentTopViewCell.m
//  CheYou
//
//  Created by lujie on 14-9-14.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouCommentTopViewCell.h"
#import "LuJieCommon.h"
#import "UIImageExt.h"
#import "UIImageView+MJWebCache.h"

#define IMAGE_HEIGHT_SIZE   34.f
#define IMAGE_WIDTH_SIZE    34.f
#define NAME_DISTANCE_WIDTH  100.f
#define TAG_DISTANCE_WIDTH  100.f

@implementation CheYouCommentTopViewCell

{
    UIImageView *userImage;
    UILabel *screen_name;
    UILabel *created_at;
    UILabel *tuCaoText;
    UILabel *footLine;
    UIView *userPhotoView;
    UIImageView *commentView;
    UILabel *typeLabel;
    UILabel *ttTimeLabel;
    UILabel *dcTimeLabel;
    UILabel *dcyyLbael;
}

@synthesize userPhotoView = userPhotoView;
@synthesize tuCaoText = tuCaoText;

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
        
        userPhotoView = [[UIView alloc] init];
        [self.contentView addSubview: userPhotoView];
        
        footLine = [[UILabel alloc] init];
        footLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
        [self.contentView addSubview: footLine];
        
        // add by lujie 2014-12-23 吐槽类型
        typeLabel = [[UILabel alloc] init];
        typeLabel.text = @"";
        typeLabel.textAlignment = NSTextAlignmentRight;
        typeLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:typeLabel];
        
        // add by lujie 2014-12-23 堵车原因
        dcyyLbael = [[UILabel alloc] initWithFrame:CGRectZero];
        dcyyLbael.text = @"";
        dcyyLbael.font = [UIFont systemFontOfSize:14];
        dcyyLbael.textAlignment = NSTextAlignmentCenter;
        dcyyLbael.layer.borderColor = [UIColor grayColor].CGColor;
        dcyyLbael.layer.borderWidth = 1;
        dcyyLbael.layer.cornerRadius = 8;
        [self.contentView addSubview:dcyyLbael];
        
        // add by lujie 2014-12-23 堵车时间
        dcTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dcTimeLabel.text = @"";
        dcTimeLabel.font = [UIFont systemFontOfSize:14];
        dcTimeLabel.textAlignment = NSTextAlignmentCenter;
        dcTimeLabel.layer.borderColor = [UIColor grayColor].CGColor;
        dcTimeLabel.layer.borderWidth = 1;
        dcTimeLabel.layer.cornerRadius = 8;
        [self.contentView addSubview:dcTimeLabel];
        
        // add by lujie 2014-12-23 贴条时间
        ttTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        ttTimeLabel.text = @"";
        ttTimeLabel.font = [UIFont systemFontOfSize:14];
        ttTimeLabel.textAlignment = NSTextAlignmentCenter;
        ttTimeLabel.layer.borderColor = [UIColor grayColor].CGColor;
        ttTimeLabel.layer.borderWidth = 1;
        ttTimeLabel.layer.cornerRadius = 8;
        [self.contentView addSubview:ttTimeLabel];

        //add by lujie for debug
//        userImage.backgroundColor = [UIColor lightGrayColor];
//        screen_name.backgroundColor = [UIColor blueColor];
//        created_at.backgroundColor = [UIColor yellowColor];
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

- (CGRect)typeLabel_Frame
{
    return CGRectMake(self.contentView.frame.size.width - 130.f, 15.f, 100.f, 20.f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [userImage setFrame:[self userImageFrame]];
    [userImage.layer setCornerRadius:CGRectGetHeight([userImage bounds]) / 2];
    userImage.layer.masksToBounds = YES;
    [screen_name setFrame:[self screen_nameFrame]];
    [created_at setFrame:[self created_atFrame]];
    [typeLabel setFrame:[self typeLabel_Frame]];
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
        // 下载图片
        if (!_tucao.hpic) {
            _tucao.hpic = @"";
        }
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
        [userImage setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",_tucao.hpic,@"!small"] placeholder:placeholder];
        screen_name.text = _tucao.nkname;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_tucao.createtime doubleValue]/1000];
        created_at.text = [formatter stringFromDate: confromTimesp];
        tuCaoText.text = _tucao.huati;
        [self makeContentFrame];
        
        typeLabel.text = @"";
        
        if ([_tucao.type integerValue] == 2) {
            typeLabel.text = @"堵车";
            typeLabel.textColor = [UIColor orangeColor];
            if (!_tucao.dccase || [_tucao.dccase isEqual:[NSNull null]]) {
                dcyyLbael.text = @"大流量";
            }else
            {
                dcyyLbael.text =  _tucao.dccase;
            }
            switch ([_tucao.jgtime integerValue]) {
                case 0:
                    dcTimeLabel.text = @"15分钟左右";
                    break;
                case 1:
                    dcTimeLabel.text = @"半小时左右";
                    break;
                case 2:
                    dcTimeLabel.text = @"堵车45分钟左右";
                    break;
                case 3:
                    dcTimeLabel.text = @"大于1个小时";
                    break;
                default:
                    dcTimeLabel.text = @"未知";
                    break;
            }
        }
        if ([_tucao.type integerValue] == 1) {
            typeLabel.text = @"贴条";
            typeLabel.textColor = [UIColor redColor];
            [formatter setDateFormat:@"yy年MM月dd日 HH时mm分"];
            confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_tucao.tttime doubleValue]];
            ttTimeLabel.text = [formatter stringFromDate: confromTimesp];
        }
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
    CGSize textSize = [tuCaoText.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    tuCaoText.frame = CGRectMake(12.f, 61.f, textSize.width, textSize.height);
    
    float typeHeight = 0.f;
    dcyyLbael.frame = CGRectZero;
    dcTimeLabel.frame = CGRectZero;
    ttTimeLabel.frame = CGRectZero;
    
    //add by lujie 2014-12-23 添加堵车标签
    if ([_tucao.type integerValue] == 2) {
        dcyyLbael.frame = CGRectMake(10.f, textSize.height + 61.f + 5.f, 120, 30);
        dcTimeLabel.frame = CGRectMake(10.f + 120.f + 10.f, textSize.height + 61.f + 5.f, 120, 30);
        typeHeight = dcyyLbael.frame.size.height + 5;
    }
    
    //add by lujie 2014-12-23 添加贴条标签
    if ([_tucao.type integerValue] == 1) {
        if (_tucao.imgList.count == 0) {
            ttTimeLabel.frame = CGRectMake(10.f, textSize.height + 61.f + 10.f, 165, 30);
        }else
        {
            ttTimeLabel.frame = CGRectMake(10.f, textSize.height + 61.f + 5.f, 165, 30);
        }
        typeHeight = ttTimeLabel.frame.size.height + 5;
    }
    
    //设置图片的位置和大小
    if (_tucao.imgList.count > 0) {
        if (_tucao.imgList.count ==1) {
            userPhotoView.frame =  CGRectMake(0, textSize.height + 70.f + typeHeight, self.contentView.bounds.size.width,100);
        }else{
            userPhotoView.frame = _tucao.imgList.count > 3 ? CGRectMake(0, textSize.height + 70.f + typeHeight, self.contentView.bounds.size.width, 170)
            : CGRectMake(0, textSize.height + 70.f + typeHeight, self.contentView.bounds.size.width, 80);
        }
    }
    //计算出cell自适应的高度
    frame.size.height = textSize.height + userPhotoView.bounds.size.height + 80.f + typeHeight;
    self.frame = frame;
    self.contentView.frame = frame;
    //最后设置foot+mid 间隔框的位置
    footLine.frame = CGRectMake(0, frame.size.height - 5.f, frame.size.width, 5.f);
}

@end
