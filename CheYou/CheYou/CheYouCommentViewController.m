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
#import "PingLun.h"
#import "CheYouPbCommentViewController.h"
#import "AFNetworking.h"

@interface CheYouCommentViewController () <PbCommentDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CheYouCommentViewController
{
    UILabel *commentLabel;
    UILabel *gasolineLabel;
    UIImageView *gasolineView;
    UIImageView *gasolinefootView;
    UIImageView *commentfootView;
    UILabel *gasolinefootLabel;
    UILabel *commentfootLabel;
    CheYouCommentTopViewCell *topCell;
    NSUserDefaults *userDefaults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self.tucao.commentList sortUsingComparator:^NSComparisonResult(PingLun *obj1,PingLun *obj2){
        return [obj1.createtime doubleValue] < [obj2.createtime doubleValue];
    }];
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
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
    //设置topcell偏移位置
    if (self.tucao.commentList.count > 0) {
        [self.tableView setContentOffset:CGPointMake(0, topCell.frame.size.height) animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.tucao.commentList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    //设置评论计数位置
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40.f)];
    sectionView.backgroundColor = [UIColor whiteColor];//[LuJieCommon UIColorFromRGB:0xd7d7d7];
    
    gasolineLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 33.f,
                                                              sectionView.frame.size.height - 29.f, 40.f, 20.f)];
    gasolineLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.tucao.jyouList count]];
    gasolineLabel.font = [UIFont systemFontOfSize:14];
    gasolineLabel.textColor = [UIColor grayColor];
    [sectionView addSubview:gasolineLabel];
    
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionView.frame.size.width/2 + 15,
                                                             sectionView.frame.size.height - 29.f, 40.f, 20.f)];
    commentLabel.text = [NSString stringWithFormat:@"%d",(int)self.tucao.commentList.count];
    commentLabel.font = [UIFont systemFontOfSize:14];
    commentLabel.textColor = [UIColor grayColor];
    [sectionView addSubview:commentLabel];
    
    gasolineView = [[UIImageView alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 57.f,
                                                                 sectionView.frame.size.height - 26.f, 15.f, 15.f)];
    gasolineView.image = [UIImage imageNamed:@"tc_gasoline_unselect"];
    [sectionView addSubview:gasolineView];
    
    UIImageView *commentView = [[UIImageView alloc] initWithFrame:CGRectMake(sectionView.frame.size.width/2 -10,
                                                                             sectionView.frame.size.height - 25.f, 15.f, 15.f)];
    commentView.image = [UIImage imageNamed:@"tc_comment"];
    [sectionView addSubview:commentView];
    
    UIImageView *commentFoot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width, 40.f)];
    commentFoot.image = [UIImage imageNamed:@"comment_foot"];
    [sectionView addSubview:commentFoot];
    //判断用户是否点过赞
    for (PingLun *jy in self.tucao.jyouList) {
        if ([[userDefaults objectForKey:@"userPhone"] isEqualToString:jy.account]) {
            gasolinefootView.image = [UIImage imageNamed:@"tc_gasoline_select"];
            gasolineLabel.textColor = [UIColor redColor];
            gasolineView.image = [UIImage imageNamed:@"tc_gasoline_select"];
        }
    }
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
        topCell = [[CheYouCommentTopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commtheaddentifier"];
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        topCell.tucao = self.tucao;
        [self makeUserPhotos:self.tucao over:topCell over:indexPath.row];
        return topCell;
    }
    CheYouCommentViewCell *cell = [[CheYouCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commtdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pinglun = [self.tucao.commentList objectAtIndex:indexPath.row];
    for(id tmpView in cell.contentView.subviews)
    {
        if([tmpView isKindOfClass:[UIButton class]])
        {
            [tmpView removeFromSuperview];
        }
    }
    //添加举报按钮
    UIButton *jubaobutton = [[UIButton alloc] initWithFrame: CGRectMake(cell.frame.size.width - 60.f, 12.f, 35.f, 25.f)];
    [jubaobutton addTarget:self action:@selector(jubaobuttonAction:)forControlEvents:UIControlEventTouchDown];
    [cell.contentView addSubview:jubaobutton];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma 生成吐槽的图片
-(void)makeUserPhotos:(TuCao *)tucao over:(CheYouCommentTopViewCell *)cell over:(NSInteger)row
{
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading"];
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

#pragma 点击照片浏览
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSInteger count =  [[self.tucao imgList] count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [@"http://cheyoulianmeng.b0.upaiyun.com" stringByAppendingString: [self.tucao.imgList objectAtIndex:i]];
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
    //    [self dismissViewControllerAnimated:YES completion: nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma 评论 点赞
- (void)gasolinebuttonAction:(id)sender
{
    for (PingLun *jy in self.tucao.jyouList) {
        if ([[userDefaults objectForKey:@"userPhone"] isEqualToString:jy.account]) {
            return;
        }
    }
    gasolinefootView.image = [UIImage imageNamed:@"tc_gasoline_select"];
    gasolineLabel.text = [NSString stringWithFormat: @"%d", [gasolineLabel.text intValue] + 1];
    gasolinefootLabel.textColor = [UIColor redColor];
    gasolineView.image = [UIImage imageNamed:@"tc_gasoline_select"];
    gasolineLabel.textColor = [UIColor redColor];
    PingLun *newzan = [[PingLun alloc] init];
    newzan.lbid = self.tucao.lbid;
    newzan.account = [userDefaults objectForKey:@"userPhone"];
    newzan.content = @"0";
    [self.tucao.jyouList addObject:newzan];
    //点赞发送服务端
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account": [userDefaults objectForKey:@"userPhone"], @"lbid":self.tucao.lbid};
    [manager POST:@"http://114.215.187.69/citypin/rs/laba/yt/1" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //                    NSLog(@"JSON: %@", responseObject);
        //向通知中心发送消息
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pbZanOrPlNotification"
         object:nil
         userInfo:[NSDictionary dictionaryWithObject:self.indexpath forKey:@"indexpath"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络错误，点赞失败！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)jubaobuttonAction:(id)sender
{
    NSString *title = NSLocalizedString(@"提示", nil);
    NSString *message = NSLocalizedString(@"举报成功！", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
}

- (void)commentbuttonAction:(id)sender
{
    
    [self performSegueWithIdentifier:@"pb_comment_segue" sender:self];
}

#pragma mark 处理segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"pb_comment_segue"]) {
        UINavigationController *nav = (UINavigationController*)segue.destinationViewController;
        CheYouPbCommentViewController *pbcommentView = (CheYouPbCommentViewController*)nav.topViewController;
        pbcommentView.lbid = self.tucao.lbid;
        pbcommentView.delegate = self;
    }
}
/*
 #pragma 请求评论数据
 - (void)getData:(int)page
 {
 //第一次获取数据
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
 NSDictionary *parameters = @{@"lbid":self.tucao.lbid};
 [manager POST:@"http://114.215.187.69/citypin/rs/laba/comment/find" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
 //        NSLog(@"responseObject: %@", responseObject);
 NSArray *labaDic = [responseObject objectForKey:@"data"];
 //遍历喇叭
 for (NSDictionary *comment in labaDic) {
 //区分评论和点赞
 if ([[comment objectForKey:@"content"] isEqual:@"0"]) {
 PingLun * pinglun = [[PingLun alloc] init];
 [pinglun setValue:[comment objectForKey:@"nkname"] forKey:@"nkname"];
 [pinglun setValue:[comment objectForKey:@"lcid"] forKey:@"lcid"];
 [pinglun setValue:[comment objectForKey:@"lbid"] forKey:@"lbid"];
 [pinglun setValue:[comment objectForKey:@"account"] forKey:@"account"];
 [pinglun setValue:[comment objectForKey:@"hpic"] forKey:@"hpic"];
 [pinglun setValue:[comment objectForKey:@"createtime"] forKey:@"createtime"];
 [pinglun setValue:[comment objectForKey:@"content"] forKey:@"content"];
 //如果该数据是新的则添加进去
 
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
 //如果该数据是新的则添加进去
 }
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 NSString *title = NSLocalizedString(@"提示", nil);
 NSString *message = NSLocalizedString(@"网络错误，没有信息！", nil);
 NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
 [alert show];
 }];
 }
 */
#pragma 已经发布评论,点赞的委托

-(void)pbComment:(PingLun *)pinglun{
    [self.tucao.commentList addObject:pinglun];
    [self.tucao.commentList sortUsingComparator:^NSComparisonResult(PingLun *obj1,PingLun *obj2){
        return [obj1.createtime doubleValue] < [obj2.createtime doubleValue];
    }];
    [self.tableView reloadData];
    //向通知中心发送消息
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"pbZanOrPlNotification"
     object:nil
     userInfo:[NSDictionary dictionaryWithObject:self.indexpath forKey:@"indexpath"]];
}

@end
