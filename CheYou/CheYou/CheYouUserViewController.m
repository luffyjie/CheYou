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
#import "AFNetworking.h"
#import "PingLun.h"

static int page;
static NSString *dianzanIdentifier=@"dianzanIdentifier";
static NSString *usertucaoIdentifier=@"usertucaoIdentifier";

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
    UITableView *tucaotableview;
    UITableView *dianzanTableview;
    NSMutableArray *_tuCaoList;
    NSMutableArray *_jyouList;
    NSMutableSet *_tuCaoSet;
    NSUserDefaults *userDefaults;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _tuCaoList = [[NSMutableArray alloc] init];
    _jyouList = [[NSMutableArray alloc] init];
    _tuCaoSet = [[NSMutableSet alloc] init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    //获取数据
    page = 1;
    //设置按钮选择状态
    [self.oilButton  setImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
    [self.oilButton  addTarget:self action:@selector(oilButtonAction:)forControlEvents:UIControlEventTouchDown];
    
    [self.labaButton  setImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
    [self.labaButton  addTarget:self action:@selector(labaButtonAction:)forControlEvents:UIControlEventTouchDown];
    
    //用户图片设置
    self.photoView.frame = CGRectMake( 10, 86, 60, 60);
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
    [self.photoView setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",[userDefaults objectForKey:@"photoUrl"],@"!basicimg"] placeholder:placeholder];
    [self.photoView.layer setCornerRadius:CGRectGetHeight([self.photoView bounds]) / 2];
    self.photoView.layer.masksToBounds = YES;
    self.nameView.text = [userDefaults objectForKey:@"userName"];
    self.signLabel.text = [@"爱车：" stringByAppendingString:[userDefaults objectForKey:@"userAiche"]];
    //初始化喇叭
    tucaotableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 203, self.view.bounds.size.width, self.view.bounds.size.height - 203 - 64)];
    [self.view addSubview:tucaotableview];
    tucaotableview.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    tucaotableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,5)];
    tucaotableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tucaotableview.delegate = self;
    tucaotableview.dataSource = self;
    tucaotableview.tag = 1;
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
    [tucaotableview headerBeginRefreshing];
    [dianzanTableview headerBeginRefreshing];
    //注册用户更改了个人信息的观察
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfo:)
                                                 name:@"UpdateUserInfoNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma getData

- (void)geTuCaoData:(int)page
{
    //第一次获取数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account": [userDefaults stringForKey:@"userPhone"], @"page.page": [NSString stringWithFormat:@"%d",page],
                                 @"page.size": @"10",@"page.sort": @"createTime", @"page.sort.dir": @"desc"};
    [manager POST:@"http://114.215.187.69/citypin/rs/laba/find" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *labaDic = [responseObject objectForKey:@"data"];
        //遍历喇叭
        for (NSDictionary *laba in labaDic) {
            TuCao *tucao  = [[TuCao alloc] init];
            [tucao setValue:[laba objectForKey:@"hpic"] forKey:@"hpic"];
            [tucao setValue:[laba objectForKey:@"nkname"] forKey:@"nkname"];
            [tucao setValue:[laba objectForKey:@"lbid"] forKey:@"lbid"];
            [tucao setValue:[laba objectForKey:@"account"] forKey:@"account"];
            [tucao setValue:[laba objectForKey:@"type"] forKey:@"type"];
            [tucao setValue:[laba objectForKey:@"huati"] forKey:@"huati"];
            [tucao setValue:[laba objectForKey:@"jyou"] forKey:@"jyou"];
            [tucao setValue:[laba objectForKey:@"location"] forKey:@"location"];
            [tucao setValue:[laba objectForKey:@"createtime"] forKey:@"createtime"];
            [tucao setValue:[laba objectForKey:@"updatetime"] forKey:@"updatetime"];
            if ([[laba objectForKey:@"img"] length] > 1) {
                NSArray *imgList = [[laba objectForKey:@"img"] componentsSeparatedByString:@";"];
                [tucao setValue:imgList forKey:@"imgList"];
            }
            //区分评论和点赞
            NSArray *comments = [laba objectForKey:@"comments"];
            if (comments.count > 0) {
                for (NSDictionary *comment in comments) {
                    if ([[comment objectForKey:@"content"] isEqual:@"0"]) {
                        PingLun * pinglun = [[PingLun alloc] init];
                        [pinglun setValue:[comment objectForKey:@"nkname"] forKey:@"nkname"];
                        [pinglun setValue:[comment objectForKey:@"lcid"] forKey:@"lcid"];
                        [pinglun setValue:[comment objectForKey:@"lbid"] forKey:@"lbid"];
                        [pinglun setValue:[comment objectForKey:@"account"] forKey:@"account"];
                        [pinglun setValue:[comment objectForKey:@"hpic"] forKey:@"hpic"];
                        [pinglun setValue:[comment objectForKey:@"createtime"] forKey:@"createtime"];
                        [pinglun setValue:[comment objectForKey:@"content"] forKey:@"content"];
                        [tucao.jyouList addObject:pinglun];
                    }else
                    {
                        PingLun * pinglun = [[PingLun alloc] init];
                        [pinglun setValue:[comment objectForKey:@"nkname"] forKey:@"nkname"];
                        [pinglun setValue:[comment objectForKey:@"lcid"] forKey:@"lcid"];
                        [pinglun setValue:[comment objectForKey:@"lbid"] forKey:@"lbid"];
                        [pinglun setValue:[comment objectForKey:@"account"] forKey:@"account"];
                        [pinglun setValue:[comment objectForKey:@"hpic"] forKey:@"hpic"];
                        [pinglun setValue:[comment objectForKey:@"createtime"] forKey:@"createtime"];
                        [pinglun setValue:[comment objectForKey:@"content"] forKey:@"content"];
                        [tucao.commentList addObject:pinglun];
                    }
                }
            }
            //如果该数据是新的则添加进去
            if (![_tuCaoSet containsObject:tucao.lbid]) {
                [_tuCaoSet addObject:tucao.lbid];
                [_tuCaoList addObject:tucao];
            }else
            {
                for (TuCao *htucao in _tuCaoList) {
                    if ([htucao.lbid integerValue]==[tucao.lbid integerValue]) {
                        [htucao setJyou:tucao.jyou];
                        [htucao setCommentList:tucao.commentList];
                        [htucao setJyouList:tucao.jyouList];
                        [htucao setHpic:tucao.hpic];
                        [htucao setNkname:tucao.nkname];
                    }
                }
            }
        }
        [_tuCaoList sortUsingComparator:^NSComparisonResult(TuCao *obj1,TuCao *obj2){
            return [obj1.createtime integerValue] < [obj2.createtime integerValue];
        }];
        for (TuCao *htuco in _tuCaoList) {
            if ([htuco.jyouList count] > 0) {
                for (PingLun *pl in htuco.jyouList) {
                    [_jyouList addObject:pl];
                }
            }
        }
        [_jyouList sortUsingComparator:^NSComparisonResult(PingLun *obj1,PingLun *obj2){
            return [obj1.createtime integerValue] < [obj2.createtime integerValue];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络错误，没有信息！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }];
    //获取喇叭，油桶总数
    parameters = @{@"account": [userDefaults stringForKey:@"userPhone"]};
    [manager POST:@"http://114.215.187.69/citypin/rs/laba/stat" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//        NSLog(@"/laba/stat: %@", dataDic);
        self.oil_num.text =  [dataDic objectForKey:@"ytcount"]?[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"ytcount"]]:@"0";
        self.laba_num.text = [dataDic objectForKey:@"labacount"]?[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"labacount"]]:@"0";
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络错误，没有信息！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma 按钮事件
- (void)oilButtonAction:(id)sender
{
    dianzanTableview.hidden = NO;
    tucaotableview.hidden = YES;
    [tucaotableview reloadData];
    self.greenLabel.frame = CGRectMake(162, 198, 157, 2);
}

- (void)labaButtonAction:(id)sender
{
    dianzanTableview.hidden = YES;
    tucaotableview.hidden = NO;
    [dianzanTableview reloadData];
    self.greenLabel.frame = CGRectMake(1, 198, 157, 2);
}

#pragma refresh config

-(void)refreshConfig
{
    [tucaotableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tucaotableview.headerPullToRefreshText = @"下拉可以刷新了";
    tucaotableview.headerReleaseToRefreshText = @"松开马上刷新了";
    tucaotableview.headerRefreshingText = @"正在刷新中...";
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tucaotableview addFooterWithTarget:self action:@selector(footerRereshing)];
    tucaotableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tucaotableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tucaotableview.footerRefreshingText = @"正在刷新中...";
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
        return _jyouList.count;
    }
    return _tuCaoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // dequeue a RecipeTableViewCell, then set its towm to the towm for the current row
    if (tableView.tag == 2) {
        CheYouDianzanViewCell *dianzanCell = [tableView dequeueReusableCellWithIdentifier:dianzanIdentifier];
        if (!dianzanCell) {
             dianzanCell = [[CheYouDianzanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dianzanIdentifier];
        }
        dianzanCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dianzanCell.dianzan = [_jyouList objectAtIndex:indexPath.row];
        return dianzanCell;
    }else{
        CheYouTuCaoTableViewCell *tucaoCell = [tableView dequeueReusableCellWithIdentifier:usertucaoIdentifier];
        if (!tucaoCell) {
            tucaoCell = [[CheYouTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:usertucaoIdentifier];
        }
        tucaoCell.tucao = [_tuCaoList objectAtIndex:indexPath.row];
        tucaoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tucaoCell.tag = [tucaoCell.tucao.lbid integerValue];
        //如果用户之前点过赞，则显示红色
        for (PingLun *jy in [[_tuCaoList objectAtIndex:indexPath.row] jyouList]) {
            if ([[userDefaults objectForKey:@"userPhone"] isEqualToString:jy.account]) {
                tucaoCell.gasolineView.image = [UIImage imageNamed:@"tc_gasoline_select"];
                tucaoCell.gasolineLabel.textColor = [UIColor redColor];
            }
        }
        if ([[[_tuCaoList objectAtIndex:indexPath.row] jyouList] count] == 0) {
            tucaoCell.gasolineView.image = [UIImage imageNamed:@"tc_gasoline_unselect"];
            tucaoCell.gasolineLabel.textColor = [UIColor blackColor];
        }
        //添加点赞加油点击按钮
        UIButton *overbutton = [[UIButton alloc] initWithFrame: CGRectMake(self.view.bounds.size.width - 60.f, tucaoCell.frame.size.height - 30.f, 40.f, 24.f)];
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
        UITableViewCell *cell = [self tableView:tucaotableview cellForRowAtIndexPath:indexPath];
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
-(void)makeUserPhotos:(TuCao *)tucao over:(CheYouTuCaoTableViewCell *)cell over:(long)row
{
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
    //因为复用了cell，所以必须remove复用的cell的图片,不然会有bug
    [cell.userPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (tucao.imgList.count == 1) {
        UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 150, 100)];
        // 下载图片
        [photo setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",[tucao.imgList objectAtIndex:0],@"!fithw"] placeholder:placeholder];
        // 事件监听
        photo.tag = (10*row);
        photo.clipsToBounds = YES;
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.userInteractionEnabled = YES;
        [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [cell.userPhotoView addSubview: photo];
        
    }
    
    if (tucao.imgList.count >1 && tucao.imgList.count < 4) {
        for (int idx = 0; idx < tucao.imgList.count; idx++) {
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80, 80, 80)];
            // 下载图片
            [photo setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",[tucao.imgList objectAtIndex:idx],@"!fithwsmall"]  placeholder:placeholder];
            // 事件监听
            photo.tag = idx+(10*row);
            photo.clipsToBounds = YES;
            photo.contentMode = UIViewContentModeScaleAspectFill;
            photo.userInteractionEnabled = YES;
            [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [cell.userPhotoView addSubview: photo];
        }
    }
    
    if(tucao.imgList.count > 3)
    {
        for (int idx = 0; idx < tucao.imgList.count; idx++) {
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*80+(idx%3+1)*10, (idx/3)*80+(idx/3)*5, 80, 80)];
            // 下载图片
            [photo setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",[tucao.imgList objectAtIndex:idx],@"!fithwsmall"]  placeholder:placeholder];
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
    NSInteger count =  [[tucao imgList] count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [@"http://cheyoulianmeng.b0.upaiyun.com" stringByAppendingString: [tucao.imgList objectAtIndex:i]];
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
    tucaotableview.showsVerticalScrollIndicator = NO;
    //1.添加数据
    page = 1;
    [self geTuCaoData:page];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tucaotableview reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tucaotableview headerEndRefreshing];
        tucaotableview.showsVerticalScrollIndicator = YES;
    });
}

- (void)footerRereshing
{
    tucaotableview.showsVerticalScrollIndicator = NO;
    // 1.添加数据
    page++;
    [self geTuCaoData:page];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tucaotableview reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tucaotableview footerEndRefreshing];
        tucaotableview.showsVerticalScrollIndicator = YES;
    });
}

- (void)dianzanheaderRereshing
{
    dianzanTableview.showsVerticalScrollIndicator = NO;
    //1.添加数据
    page = 1;
    [self geTuCaoData:page];
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
    // 1.添加数据
    page++;
    [self geTuCaoData:page];
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
        NSIndexPath *indexPath = [tucaotableview indexPathForSelectedRow];
        commentView.tucao = [_tuCaoList objectAtIndex:indexPath.row];
        commentView.indexpath = indexPath;
    }
    if ([segue.identifier isEqual:@"set_segue"]) {
        CheYouSetViewController *setView = (CheYouSetViewController *)segue.destinationViewController;
        setView.hidesBottomBarWhenPushed = YES;
    }
    
}

#pragma 评论 点赞
- (void)gasolinebuttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    //这里7.0以上版本和之前版本取值不同，程序会crash
    CheYouTuCaoTableViewCell *cell;
    float version=[[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=7.0)
    {
        cell=(CheYouTuCaoTableViewCell *)[[button superview] superview];
    }
    else
    {
        cell = (CheYouTuCaoTableViewCell *)[[[button superview] superview]superview];
    }
    //判断是否点过赞
    for (PingLun *jy in [[cell tucao] jyouList]) {
        if ([[userDefaults objectForKey:@"userPhone"] isEqualToString:jy.account]) {
            return;
        }
    }
    cell.gasolineView.image = [UIImage imageNamed:@"tc_gasoline_select"];
    cell.gasolineLabel.text = [NSString stringWithFormat: @"%d", [cell.gasolineLabel.text intValue] + 1];
    cell.gasolineLabel.textColor = [UIColor redColor];
    PingLun *newzan = [[PingLun alloc] init];
    newzan.lbid = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    newzan.account = [userDefaults objectForKey:@"userPhone"];
    newzan.content = @"0";
    for (TuCao *tc in _tuCaoList) {
        if ([tc.lbid integerValue]==cell.tag) {
            [tc.jyouList addObject:newzan];
        }
    }
    //点赞发送服务端
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account": [userDefaults objectForKey:@"userPhone"], @"lbid":[NSNumber numberWithInteger:cell.tag]};
    [manager POST:@"http://114.215.187.69/citypin/rs/laba/yt/1" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络错误，点赞失败！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma 处理用户更新信息
- (void)updateUserInfo:(NSNotification*)notification
{
    //接受notification的userInfo，可以把参数存进此变量
    NSDictionary *theData = [notification userInfo];
    NSString *photoUrl = [theData objectForKey:@"hpic"];
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
    [self.photoView setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",photoUrl,@"!basicimg"] placeholder:placeholder];
    self.nameView.text = [theData objectForKey:@"nkname"];
    self.signLabel.text = [@"爱车：" stringByAppendingString:[theData objectForKey:@"vehtype"]];
    [tucaotableview headerBeginRefreshing];
    [dianzanTableview headerBeginRefreshing];
}

@end
