//
//  CheYouUserViewController.m
//  CheYou
//
//  Created by lujie on 14-9-9.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouUserViewController.h"
#import "TuCao.h"
#import "CheYouTuCaoTableViewCell.h"
#import "LuJieCommon.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MJRefresh.h"
#import "CheYouDianzanViewCell.h"
#import "CheYouCommentViewController.h"
#import "CheYouSetViewController.h"

@interface CheYouUserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *oilButton;
@property (weak, nonatomic) IBOutlet UILabel *oil_num;
@property (weak, nonatomic) IBOutlet UIButton *labaButton;
@property (weak, nonatomic) IBOutlet UILabel *laba_num;
@property (strong, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *setButton;

@end

@implementation CheYouUserViewController
{
    UITableView *tableview;
    UITableView *dianzanTableview;
    NSMutableArray *_tuCaoList;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //获取测试数据
    [self getDataFormFiles];
    //设置按钮选择状态
    [self.oilButton  setImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
    [self.oilButton  addTarget:self action:@selector(oilButtonAction:)forControlEvents:UIControlEventTouchDown];
    
    [self.labaButton  setImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
    [self.labaButton  addTarget:self action:@selector(labaButtonAction:)forControlEvents:UIControlEventTouchDown];
    
    //用户图片设置
    self.photoView.frame = CGRectMake( 10, 86, 60, 60);
    
    //初始化喇叭
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 203, self.view.bounds.size.width, self.view.bounds.size.height - 203 - 64)];
    [self.view addSubview:tableview];
    tableview.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,5)];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tag = 1;
    //创建刷新
    [self refreshConfig];
    
    //初始化点赞
    dianzanTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 203, self.view.bounds.size.width, self.view.bounds.size.height - 203 - 64)];
    [self.view addSubview:dianzanTableview];
    dianzanTableview.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    dianzanTableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,5)];
    dianzanTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    dianzanTableview.delegate = self;
    dianzanTableview.dataSource = self;
    dianzanTableview.tag = 2;
    dianzanTableview.hidden = YES;
    //创建刷新
    [self refreshDianzanConfig];
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



#pragma 按钮事件
- (void)oilButtonAction:(id)sender
{
    dianzanTableview.hidden = NO;
    tableview.hidden = YES;
    [tableview reloadData];
    self.greenLabel.frame = CGRectMake(108, 198, 104, 2);
}

- (void)labaButtonAction:(id)sender
{
    dianzanTableview.hidden = YES;
    tableview.hidden = NO;
    [dianzanTableview reloadData];
    self.greenLabel.frame = CGRectMake(1, 198, 104, 2);
}

#pragma refresh config

-(void)refreshConfig
{
    [tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableview.headerPullToRefreshText = @"下拉可以刷新了";
    tableview.headerReleaseToRefreshText = @"松开马上刷新了";
    tableview.headerRefreshingText = @"正在刷新中...";
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    tableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableview.footerRefreshingText = @"正在刷新中...";
}

-(void)refreshDianzanConfig
{
    [dianzanTableview addHeaderWithTarget:self action:@selector(dianzanheaderRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    dianzanTableview.headerPullToRefreshText = @"下拉可以刷新了";
    dianzanTableview.headerReleaseToRefreshText = @"松开马上刷新了";
    dianzanTableview.headerRefreshingText = @"正在刷新中...";
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [dianzanTableview addFooterWithTarget:self action:@selector(dianzanfooterRereshing)];
    dianzanTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
    dianzanTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    dianzanTableview.footerRefreshingText = @"正在刷新中...";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 2) {
        return 2;
    }
    return _tuCaoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // dequeue a RecipeTableViewCell, then set its towm to the towm for the current row
   
    if (tableView.tag == 2) {

        CheYouDianzanViewCell *dianzanCell = [[CheYouDianzanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sconddentifier"];
        dianzanCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dianzanCell.tucao = [_tuCaoList objectAtIndex:indexPath.row];
        return dianzanCell;
    }else{
        
        CheYouTuCaoTableViewCell *tucaoCell = [[CheYouTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sconddentifier"];
        tucaoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tucaoCell.tucao = [_tuCaoList objectAtIndex:indexPath.row];
        //添加点赞加油点击按钮
        UIButton *overbutton = [[UIButton alloc] initWithFrame: CGRectMake(self.view.bounds.size.width - 95.f, tucaoCell.frame.size.height - 35.f, 65.f, 30.f)];
        [overbutton addTarget:self action:@selector(gasolinebuttonAction:)forControlEvents:UIControlEventTouchDown];
        [tucaoCell.contentView addSubview:overbutton];
        [self makeUserPhotos:[_tuCaoList objectAtIndex:indexPath.row] over:tucaoCell over:indexPath.row];
        return tucaoCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2) {
        return 48;
    }else{
        UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        [self performSegueWithIdentifier:@"my_comment_segue" sender:self];
    }
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

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    tableview.showsVerticalScrollIndicator = NO;
    // 1.添加假数据
    for (NSInteger i = 0; i<5; i++) {
        [_tuCaoList addObject:[_tuCaoList objectAtIndex:i]];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableview headerEndRefreshing];
        tableview.showsVerticalScrollIndicator = YES;
    });
}

- (void)footerRereshing
{
    tableview.showsVerticalScrollIndicator = NO;
    // 1.添加假数据
    for (NSInteger i = 0; i<5; i++) {
        [_tuCaoList addObject:[_tuCaoList objectAtIndex:i]];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableview footerEndRefreshing];
        tableview.showsVerticalScrollIndicator = YES;
    });
}

- (void)dianzanheaderRereshing
{
    dianzanTableview.showsVerticalScrollIndicator = NO;
    // 1.添加假数据
    for (NSInteger i = 0; i<5; i++) {
        [_tuCaoList addObject:[_tuCaoList objectAtIndex:i]];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [dianzanTableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [dianzanTableview headerEndRefreshing];
        dianzanTableview.showsVerticalScrollIndicator = YES;
    });
}

- (void)dianzanfooterRereshing
{
    dianzanTableview.showsVerticalScrollIndicator = NO;
    // 1.添加假数据
    for (NSInteger i = 0; i<5; i++) {
        [_tuCaoList addObject:[_tuCaoList objectAtIndex:i]];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [dianzanTableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [dianzanTableview footerEndRefreshing];
        dianzanTableview.showsVerticalScrollIndicator = YES;
    });
}

#pragma 设置按钮
- (IBAction)setButton:(id)sender {
    
    [self performSegueWithIdentifier:@"set_segue" sender:self];
}

#pragma mark 处理segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"my_comment_segue"]) {
        CheYouCommentViewController *commentView = (CheYouCommentViewController *)segue.destinationViewController;
        commentView.hidesBottomBarWhenPushed = YES;
        NSIndexPath *indexPath = [tableview indexPathForSelectedRow];
        commentView.tucao = [_tuCaoList objectAtIndex:indexPath.row];
        commentView.indexpath = indexPath;
    }
    if ([segue.identifier isEqual:@"set_segue"]) {
        CheYouSetViewController *setView = (CheYouSetViewController *)segue.destinationViewController;
        setView.hidesBottomBarWhenPushed = YES;
    }
    
}

#pragma 评论 点赞
#pragma 评论 点赞 点击附件图片 事件处理
- (void)gasolinebuttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    CheYouTuCaoTableViewCell *cell=(CheYouTuCaoTableViewCell *)[[[button superview] superview]superview];
    if (button.selected) {
        cell.gasolineView.image = [UIImage imageNamed:@"tc_gasoline_select"];
        cell.gasolineLabel.text = [NSString stringWithFormat: @"%d", [cell.gasolineLabel.text intValue] + 1];
        cell.gasolineLabel.textColor = [UIColor redColor];
    }
}

@end
