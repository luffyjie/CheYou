//
//  CheYouCommentViewController.m
//  CheYou
//
//  Created by lujie on 14-9-10.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouCommentViewController.h"
#import "LuJieCommon.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface CheYouCommentViewController ()

@end

@implementation CheYouCommentViewController
{
    UIView *headView;
    UIImageView *userImage;
    UILabel *screen_name;
    UILabel *created_at;
    UILabel *tuCaoText;
    UILabel *midLine;
    UILabel *footLine;
    UIView *userPhotoView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableHeaderView = [self makeHeadview];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0,self.tableView.tableHeaderView.bounds.size.height) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return self.tableView.tableHeaderView.bounds.size.height;
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma 生成headview

-(UIView *)makeHeadview
{
    headView = [[UIView alloc] init];
    
    userImage = [[UIImageView alloc] initWithFrame:CGRectMake( 12.f, 12.f, 34.f, 34.f)];
    [headView addSubview: userImage];
    
    screen_name = [[UILabel alloc] initWithFrame:CGRectMake(34.f + 12.f + 15.f, 15.f, 100.f, 20.f)];
    screen_name.font = [UIFont boldSystemFontOfSize:14.f];
    [headView addSubview: screen_name];
    
    created_at = [[UILabel alloc] initWithFrame:CGRectMake(34.f + 12.f + 15.f, 38.f, 100.f, 12.f)];
    created_at.font = [UIFont boldSystemFontOfSize:10.f];
    [headView addSubview: created_at];
    
    tuCaoText = [[UILabel alloc] init];
    tuCaoText.font = [UIFont systemFontOfSize:14.f];
    [headView addSubview: tuCaoText];
    
    userPhotoView = [[UIView alloc] init];
    [headView addSubview: userPhotoView];
    
    footLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- 34.f, self.view.frame.size.width, 1.0f)];
    footLine.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    [headView addSubview: footLine];
    
    userImage.image = [UIImage imageNamed:self.tucao.profile_image_url];
    screen_name.text = self.tucao.screen_name;
    created_at.text = self.tucao.created_at;
    tuCaoText.text = self.tucao.tuCaotext;
    
    //计算设置headView的高度
    //设置label的最大行数
    tuCaoText.numberOfLines = 0;
    CGSize size = CGSizeMake(self.view.frame.size.width - 12.f - 12.f, 1000);
    CGSize textSize = [tuCaoText.text sizeWithFont:tuCaoText.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    tuCaoText.frame = CGRectMake(12.f, 61.f, textSize.width, textSize.height);
    //设置图片的位置和大小
    if (self.tucao.pic_urls.count > 0) {
        if (self.tucao.pic_urls.count ==1) {
            userPhotoView.frame =  CGRectMake(0, textSize.height + 70.f, self.view.bounds.size.width,100);
        }else{
            userPhotoView.frame = _tucao.pic_urls.count > 3 ? CGRectMake(0, textSize.height + 70.f, self.view.bounds.size.width, 170)
            : CGRectMake(0, textSize.height + 70.f, self.view.bounds.size.width, 80);
        }
    }
    //计算出cell自适应的高度
    headView.frame = CGRectMake(0, 0, self.view.frame.size.width, textSize.height + userPhotoView.bounds.size.height + 80.f);
    //最后设置foot+mid 间隔框的位置
    footLine.frame = CGRectMake(0, headView.frame.size.height - 5.f, headView.frame.size.width, 5.f);
    midLine.frame = CGRectMake(0, headView.frame.size.height - 34.f, headView.frame.size.width, 1.0f);
    
    //生成图片列表
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
    if (self.tucao.pic_urls.count == 1) {
        UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 150, 100)];
        // 下载图片
        [photo setImageURLStr: [self.tucao.pic_urls objectAtIndex:0] placeholder:placeholder];
        // 事件监听
        photo.tag = 0;
        photo.clipsToBounds = YES;
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.userInteractionEnabled = YES;
        [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [userPhotoView addSubview: photo];
        
    }
    
    if (self.tucao.pic_urls.count >1 && self.tucao.pic_urls.count < 4) {
        userPhotoView.frame = CGRectMake(0, textSize.height + 70.f, textSize.width, 80);
        for (int idx = 0; idx < self.tucao.pic_urls.count; idx++) {
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80, 80, 80)];
            // 下载图片
            [photo setImageURLStr: [self.tucao.pic_urls objectAtIndex:idx] placeholder:placeholder];
            // 事件监听
            photo.tag = idx+(10*self.indexpath.row);
            photo.clipsToBounds = YES;
            photo.contentMode = UIViewContentModeScaleAspectFill;
            photo.userInteractionEnabled = YES;
            [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [userPhotoView addSubview: photo];
        }
    }
    
    if(self.tucao.pic_urls.count > 3)
    {
        userPhotoView.frame = CGRectMake(0, textSize.height + 70.f, textSize.width, 170);
        for (int idx = 0; idx < self.tucao.pic_urls.count; idx++) {
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80+(idx/3)*5, 80, 80)];
            // 下载图片
            [photo setImageURLStr: [self.tucao.pic_urls objectAtIndex:idx] placeholder:placeholder];
            // 事件监听
            photo.tag = idx+(10*self.indexpath.row);
            photo.clipsToBounds = YES;
            photo.contentMode = UIViewContentModeScaleAspectFill;
            photo.userInteractionEnabled = YES;
            [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [userPhotoView addSubview: photo];
        }
    }

    return headView;
}

#pragma 点击照片浏览
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSInteger count =  [[self.tucao pic_urls] count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [[[self.tucao pic_urls] objectAtIndex:i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径]
        photo.srcImageView = tap.view.superview.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = (tap.view.tag%10); // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
