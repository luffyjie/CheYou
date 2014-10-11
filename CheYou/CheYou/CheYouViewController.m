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
#import "MJRefresh.h"
#import "CheYouCommentViewController.h"
#import "AFNetworking.h"
#import "PingLun.h"

NSString *const MJTableViewCellIdentifier = @"sconddentifier";
static NSString *hometucaoIdentifier=@"hometucaoIdentifier";
static int page;

@interface CheYouViewController ()

@end

@implementation CheYouViewController
{
    NSMutableArray *_tuCaoList;
    NSMutableSet *_zanSet;
    NSUserDefaults *userDefaults;
    NSMutableSet *_tuCaoSet;
    NSString *starttime;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    starttime = [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:-30*24*60*60]];
    userDefaults = [NSUserDefaults standardUserDefaults];
    _zanSet = [[NSMutableSet alloc] init];
    _tuCaoSet = [[NSMutableSet alloc] init];
    _tuCaoList = [[NSMutableArray alloc] init];
    page = 1;
	// Do any additional setup after loading the view, typically from a nib.
    //设置吐槽tale
    self.tableView.backgroundColor = [LuJieCommon UIColorFromRGB:0xF2F2F2];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,10)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //刷新获取数据
    [self refreshConfig];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma getData

- (void)getData:(int)page
{
    //第一次获取数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"location": [userDefaults stringForKey:@"userArea"], @"starttime": starttime,
                                 @"page.page": [NSString stringWithFormat:@"%d",page],
                                 @"page.size": @"10",@"page.sort": @"createTime", @"page.sort.dir": @"desc"};
    [manager POST:@"http://114.215.187.69/citypin/rs/laba/find/round" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject: %@", responseObject);
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
                    }
                }
            }
        }
        if (page==1) {
            [_tuCaoList sortUsingComparator:^NSComparisonResult(TuCao *obj1,TuCao *obj2){
                return [obj1.createtime integerValue] < [obj2.createtime integerValue];
            }];
        }
        //请求完毕，刷新table
//        [self.tableView reloadData ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络错误，没有信息！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma refresh config

-(void)refreshConfig
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新中...";
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在刷新中...";
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
    CheYouTuCaoTableViewCell *tucaoCell = [tableView dequeueReusableCellWithIdentifier:hometucaoIdentifier];
    if (!tucaoCell) {
         tucaoCell = [[CheYouTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hometucaoIdentifier];
    }
//    CheYouTuCaoTableViewCell *tucaoCell = [[CheYouTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hometucaoIdentifier];
    tucaoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tucaoCell.tucao = [_tuCaoList objectAtIndex:indexPath.row];
    tucaoCell.tag = [tucaoCell.tucao.lbid integerValue];
    //如果用户之前点过赞，则显示红色
    if ([_zanSet containsObject:[NSNumber numberWithInteger:tucaoCell.tag]]) {
        tucaoCell.gasolineView.image = [UIImage imageNamed:@"tc_gasoline_select"];
        tucaoCell.gasolineLabel.textColor = [UIColor redColor];
        tucaoCell.gasolineLabel.text = [NSString stringWithFormat: @"%d", [tucaoCell.gasolineLabel.text intValue] + 1];
    }
    //添加点赞加油点击按钮
    UIButton *overbutton = [[UIButton alloc] initWithFrame: CGRectMake(self.view.bounds.size.width - 60.f, tucaoCell.frame.size.height - 30.f, 40.f, 24.f)];
    [overbutton addTarget:self action:@selector(gasolinebuttonAction:)forControlEvents:UIControlEventTouchDown];
    [tucaoCell.contentView addSubview:overbutton];
    [self makeUserPhotos:[_tuCaoList objectAtIndex:indexPath.row] over:tucaoCell over:(int)indexPath.row];
    return tucaoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"comment_segue" sender:self];
}

#pragma 评论 点赞 点击附件图片 事件处理
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
    if (button.selected && ![_zanSet containsObject:[NSNumber numberWithInteger:cell.tag]]) {
        cell.gasolineView.image = [UIImage imageNamed:@"tc_gasoline_select"];
        cell.gasolineLabel.text = [NSString stringWithFormat: @"%d", [cell.gasolineLabel.text intValue] + 1];
        cell.gasolineLabel.textColor = [UIColor redColor];
        [_zanSet addObject:[NSNumber numberWithInteger:cell.tag]];
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
}

#pragma 生成吐槽的图片
-(void)makeUserPhotos:(TuCao *)tucao over:(CheYouTuCaoTableViewCell *)cell over:(int)row
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
            [photo setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",[tucao.imgList objectAtIndex:idx],@"!fithwsmall"] placeholder:placeholder];
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
            [photo setImageURLStr: [NSString stringWithFormat:@"http://cheyoulianmeng.b0.upaiyun.com%@%@",[tucao.imgList objectAtIndex:idx],@"!fithwsmall"] placeholder:placeholder];
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
    self.tableView.showsVerticalScrollIndicator = NO;
    //1.添加数据
    page = 1;
    [self getData:page];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        self.tableView.showsVerticalScrollIndicator = YES;
    });
}

- (void)footerRereshing
{
    self.tableView.showsVerticalScrollIndicator = NO;
    // 1.添加数据
    page++;
    [self getData:page];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
        self.tableView.showsVerticalScrollIndicator = YES;
    });
}

#pragma mark 处理segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"comment_segue"]) {
        CheYouCommentViewController *commentView = (CheYouCommentViewController *)segue.destinationViewController;
        commentView.hidesBottomBarWhenPushed = YES;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        commentView.tucao = [_tuCaoList objectAtIndex:indexPath.row];
        commentView.indexpath = indexPath;
    }
    
}

@end
