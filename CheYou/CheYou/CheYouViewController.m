//
//  CheYouViewController.m
//  CheYou
//
//  Created by lujie on 14-8-26.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouViewController.h"
#import "TuCao.h"
#import "CheYouTuCaoTableViewCell.h"
#import "LuJieCommon.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface CheYouViewController ()
@property (nonatomic, strong) UIImageView *scroll;

@end

@implementation CheYouViewController
{
    NSMutableArray *_tuCaoList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取测试数据
    [self getDataFormFiles];
	// Do any additional setup after loading the view, typically from a nib.
    //设置吐槽tale
    self.tableView.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,10)];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
}

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    self.scroll.hidden = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    self.scroll.hidden = YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取属性文件数据
-(void)getDataFormFiles
{
    _tuCaoList = [[NSMutableArray alloc] init];
	NSArray *parkDictionaries = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TuCaoList" ofType:@"plist"]];
	NSArray *propertyNames = [[NSArray alloc] initWithObjects:@"tu_id", @"screen_name", @"profile_image_url", @"tuCaotext",
                              @"tuCaotag", @"created_at", @"pic_urls",nil];
    
	for (NSDictionary *tuCaoDic in parkDictionaries) {
		TuCao *tucao = [[TuCao alloc] init];
		for (NSString *property in propertyNames) {
            
            [tucao setValue:[tuCaoDic objectForKey:property] forKey:property];
		}
		[_tuCaoList addObject:tucao];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tuCaoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // dequeue a RecipeTableViewCell, then set its towm to the towm for the current row
//    CheYouTuCaoTableViewCell *tucaoCell = (CheYouTuCaoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sconddentifier"];
//    if (tucaoCell == nil){
    CheYouTuCaoTableViewCell *tucaoCell = [[CheYouTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sconddentifier"];
//    }
    tucaoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tucaoCell.tucao = [_tuCaoList objectAtIndex:indexPath.row];
    //添加吐槽下方点赞 评论 按钮
    UIButton *gasolinebutton = [[UIButton alloc] initWithFrame: CGRectMake(12, tucaoCell.frame.size.height - 40.f, 20.f, 20.f)];
    [gasolinebutton setImage:[UIImage imageNamed:@"tc_gasoline_unselect"] forState:UIControlStateNormal];
    [gasolinebutton setImage:[UIImage imageNamed:@"tc_gasoline_select"] forState:UIControlStateSelected];
    [gasolinebutton addTarget:self action:@selector(gasolinebuttonAction:)forControlEvents:UIControlEventTouchDown];
    [tucaoCell.contentView addSubview:gasolinebutton];
    
    UIButton *commentbutton = [[UIButton alloc] initWithFrame:CGRectMake(90, tucaoCell.frame.size.height - 40.f, 20.f, 20.f)];
    [commentbutton setImage:[UIImage imageNamed:@"tc_comment"] forState:UIControlStateNormal];
    [commentbutton addTarget:self action:@selector(commentbuttonAction:)forControlEvents:UIControlEventTouchDown];
    [tucaoCell.contentView addSubview:commentbutton];
    [self makeUserPhotos:[_tuCaoList objectAtIndex:indexPath.row] over:tucaoCell over:indexPath.row];
    return tucaoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma 评论 点赞 点击附件图片 事件处理
- (void)gasolinebuttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (void)commentbuttonAction:(id)sender
{
    
}

- (void)photoPress:(id)sender
{
//   UIImageView *photo = (UIImageView *)sender;
    NSLog(@"photoPress");
}

#pragma 生成吐槽的图片
-(void)makeUserPhotos:(TuCao *)tucao over:(CheYouTuCaoTableViewCell *)cell over:(int)row
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

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    TuCao *tucao = [_tuCaoList objectAtIndex:(tap.view.tag/10)];
    NSInteger count =  [[tucao pic_urls] count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [[[tucao pic_urls] objectAtIndex:i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
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
