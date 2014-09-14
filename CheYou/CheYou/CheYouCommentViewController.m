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
#import "CheYouCommentViewCell.h"
#import "CheYouCommentTopViewCell.h"

@interface CheYouCommentViewController ()

@end

@implementation CheYouCommentViewController
{
    NSMutableArray *commentList;
    UILabel *commentLabel;
    UILabel *gasolineLabel;
    CheYouCommentTopViewCell *topCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDataFormFiles];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,10)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0, topCell.frame.size.height + 10) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取属性文件数据
-(void)getDataFormFiles
{
    commentList = [[NSMutableArray alloc] init];
	NSArray *parkDictionaries = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TuCaoList" ofType:@"plist"]];
	NSArray *propertyNames = [[NSArray alloc] initWithObjects:@"tu_id", @"screen_name", @"profile_image_url", @"tuCaotext",
                              @"tuCaotag", @"created_at", @"pic_urls",nil];
    
	for (NSDictionary *tuCaoDic in parkDictionaries) {
		TuCao *tucao = [[TuCao alloc] init];
		for (NSString *property in propertyNames) {
            
            [tucao setValue:[tuCaoDic objectForKey:property] forKey:property];
		}
		[commentList addObject:tucao];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return commentList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    //设置评论计数位置
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40.f)];
    sectionView.backgroundColor = [UIColor whiteColor];//[LuJieCommon UIColorFromRGB:0xd7d7d7];
    
    gasolineLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 45.f,
                                                                       sectionView.frame.size.height - 29.f, 40.f, 20.f)];
    gasolineLabel.text = self.tucao.tu_id;
    gasolineLabel.font = [UIFont systemFontOfSize:14];
    gasolineLabel.textColor = [UIColor grayColor];
    [sectionView addSubview:gasolineLabel];
    
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.frame.size.width/2 + 10,
                                                                      sectionView.frame.size.height - 29.f, 40.f, 20.f)];
    commentLabel.text = self.tucao.tu_id;
    commentLabel.font = [UIFont systemFontOfSize:14];
    commentLabel.textColor = [UIColor grayColor];
    [sectionView addSubview:commentLabel];
    
    UIImageView *gasolineView = [[UIImageView alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 75.f,
                                                                              sectionView.frame.size.height - 26.f, 15.f, 15.f)];
    gasolineView.image = [UIImage imageNamed:@"tc_gasoline_unselect"];
    [sectionView addSubview:gasolineView];
    
    UIImageView *commentView = [[UIImageView alloc] initWithFrame:CGRectMake(sectionView.frame.size.width/2 - 20,
                                                                             sectionView.frame.size.height - 25.f, 15.f, 15.f)];
    commentView.image = [UIImage imageNamed:@"tc_comment"];
    [sectionView addSubview:commentView];
    
    UIImageView *commentFoot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width, 40.f)];
    commentFoot.image = [UIImage imageNamed:@"comment_foot"];
    [sectionView addSubview:commentFoot];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40.f;
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        topCell = [[CheYouCommentTopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sconddentifier"];
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        topCell.tucao = self.tucao;
        [self makeUserPhotos:self.tucao over:topCell over:indexPath.row];
        return topCell;
    }
    CheYouCommentViewCell *cell = [[CheYouCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sconddentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tucao = [commentList objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma 生成吐槽的图片
-(void)makeUserPhotos:(TuCao *)tucao over:(CheYouCommentTopViewCell *)cell over:(int)row
{
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
    if (tucao.pic_urls.count == 1) {
        UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 150, 100)];
        // 下载图片
        [photo setImageURLStr: [tucao.pic_urls objectAtIndex:0] placeholder:placeholder];
        // 事件监听
        photo.tag = 0;
        photo.clipsToBounds = YES;
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.userInteractionEnabled = YES;
        [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [cell.userPhotoView addSubview: photo];
        
    }
    
    if (tucao.pic_urls.count >1 && tucao.pic_urls.count < 4) {
        cell.userPhotoView.frame = CGRectMake(0, cell.tuCaoText.bounds.size.height + 70.f, cell.contentView.bounds.size.width, 80);
        for (int idx = 0; idx < tucao.pic_urls.count; idx++) {
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80, 80, 80)];
            // 下载图片
            [photo setImageURLStr: [tucao.pic_urls objectAtIndex:idx] placeholder:placeholder];
            // 事件监听
            photo.tag = idx+(10*row);
            photo.clipsToBounds = YES;
            photo.contentMode = UIViewContentModeScaleAspectFill;
            photo.userInteractionEnabled = YES;
            [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [cell.userPhotoView addSubview: photo];
        }
    }
    
    if(tucao.pic_urls.count > 3)
    {
        cell.userPhotoView.frame = CGRectMake(0, cell.tuCaoText.bounds.size.height + 70.f, cell.contentView.bounds.size.width, 170);
        for (int idx = 0; idx < tucao.pic_urls.count; idx++) {
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80+(idx/3)*5, 80, 80)];
            // 下载图片
            [photo setImageURLStr: [tucao.pic_urls objectAtIndex:idx] placeholder:placeholder];
            // 事件监听
            photo.tag = idx+(10*row);
            photo.clipsToBounds = YES;
            photo.contentMode = UIViewContentModeScaleAspectFill;
            photo.userInteractionEnabled = YES;
            [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [cell.userPhotoView addSubview: photo];
        }
    }
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
