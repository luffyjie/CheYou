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
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CheYouCommentViewController
{
    NSMutableArray *commentList;
    UILabel *commentLabel;
    UILabel *gasolineLabel;
    UIImageView *gasolinefootView;
    UIImageView *commentfootView;
    UILabel *gasolinefootLabel;
    UILabel *commentfootLabel;
    CheYouCommentTopViewCell *topCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDataFormFiles];
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"返回"
                                   style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    backButton.image = [UIImage imageNamed:@"back"];
    [self.navigationItem setLeftBarButtonItem:backButton];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,10)];
    //底部工具栏
    [self footBar];
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

#pragma 底部工具栏

-(void)footBar
{
    //设置底部工具栏
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44.f, self.view.bounds.size.width, 44.f)];
    sectionView.backgroundColor = [LuJieCommon UIColorFromRGB:0xe4e4e4];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.bounds.size.width - 122, sectionView.frame.size.height - 32.f, 1.f, 20.f)];
    lineLabel.backgroundColor = [LuJieCommon UIColorFromRGB:0x868686];
    [sectionView addSubview:lineLabel];
    
    //添加一个透明的按钮到点赞按钮上方，增大接触面积
    UIButton *gasolinebutton = [[UIButton alloc] initWithFrame: CGRectMake(sectionView.frame.size.width - 105,
                                                                           sectionView.frame.size.height - 40.f, 70.f, 35.f)];
    [gasolinebutton addTarget:self action:@selector(gasolinebuttonAction:)forControlEvents:UIControlEventTouchDown];
    [sectionView addSubview:gasolinebutton];
    
    UIButton *commentbutton = [[UIButton alloc] initWithFrame: CGRectMake(sectionView.frame.size.width - 210,
                                                                          sectionView.frame.size.height - 40.f, 70.f, 35.f)];
    [commentbutton addTarget:self action:@selector(commentbuttonAction:)forControlEvents:UIControlEventTouchDown];
    [sectionView addSubview:commentbutton];
    
    gasolinefootView = [[UIImageView alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 95, sectionView.frame.size.height - 32.f, 20, 20)];
    gasolinefootView.image = [UIImage imageNamed:@"tc_gasoline_unselect"];
    [sectionView addSubview:gasolinefootView];
    
    gasolinefootLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 65, sectionView.frame.size.height - 32.f, 50, 20)];
    gasolinefootLabel.text = @"加油";
    gasolinefootLabel.font = [UIFont systemFontOfSize:13];
    [sectionView addSubview:gasolinefootLabel];
    
    commentfootView = [[UIImageView alloc] initWithFrame:CGRectMake(sectionView.frame.size.width-200, sectionView.frame.size.height - 32.f, 20, 20)];
    commentfootView.image = [UIImage imageNamed:@"tc_comment"];
    [sectionView addSubview:commentfootView];
    
    commentfootLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 170, sectionView.frame.size.height - 32.f, 50, 20)];
    commentfootLabel.text = @"评论";
    commentfootLabel.font = [UIFont systemFontOfSize:13];
    [sectionView addSubview:commentfootLabel];
    
    [self.view addSubview:sectionView];
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
    
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.frame.size.width/2 + 11,
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

#pragma 导航返回
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion: nil];
}

#pragma 评论 点赞
- (void)gasolinebuttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        gasolinefootView.image = [UIImage imageNamed:@"tc_gasoline_select"];
        gasolineLabel.text = [NSString stringWithFormat: @"%d", [gasolineLabel.text intValue] + 1];
        gasolinefootLabel.textColor = [UIColor redColor];
    }
}

- (void)commentbuttonAction:(id)sender
{
//    [self performSegueWithIdentifier:@"comment_segue" sender:self];
}

@end
