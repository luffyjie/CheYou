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

@interface CheYouViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tuCaoTableView;

@end

@implementation CheYouViewController
{
    NSMutableArray *_tuCaoList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取测试数据
//    [self getDataFormFiles];
	// Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"%@",_tuCaoList);
    
    
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
        NSLog(@"%@",parkDictionaries);
	NSArray *propertyNames = [[NSArray alloc] initWithObjects:@"tu_id", @"screen_name",
                              @"profile_image_url", @"tuCaotext", @"tuCaotag", @"created_at", nil];
	for (NSDictionary *townDictionary in parkDictionaries) {
		TuCao *tucao = [[TuCao alloc] init];
		for (NSString *property in propertyNames) {
            [tucao setValue:[townDictionary objectForKey:property] forKey:property];
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
    CheYouTuCaoTableViewCell *tocaoCell = (CheYouTuCaoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sconddentifier"];
    if (tocaoCell == nil){
        tocaoCell = [[CheYouTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sconddentifier"];
    }
    tocaoCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return tocaoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置cell的高度
    return 200.0;
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
