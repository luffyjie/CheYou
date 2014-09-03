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
    
    return tucaoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)angerButton:(id)sender {
    NSLog(@"angerButton");
}

- (IBAction)chatButton:(id)sender {
    NSLog(@"chatButton");
}

- (IBAction)xelementButton:(id)sender {
    NSLog(@"xelementButton");
}


@end
