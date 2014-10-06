//
//  CheYouDucheViewController.m
//  CheYou
//
//  Created by lujie on 14-9-2.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouDucheViewController.h"
#import "LuJieCommon.h"
#import "PRButton.h"
#import "AFNetworking.h"
#import "UpYun.h"
#import "UIImageExt.h"

@interface CheYouDucheViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (strong, nonatomic) IBOutlet UIView *keywordBarView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet PRButton *ducheCaseButton;
@property (weak, nonatomic) IBOutlet PRButton *ducheTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *ducheLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) UIPickerView *casepicker;
@property (strong, nonatomic) UIPickerView *timepicker;

@end

@implementation CheYouDucheViewController

{
    UILabel *promptLabel;
    NSMutableArray *userPhotoList;
    NSMutableArray *caseList;
    NSMutableArray *timeList;
    NSString *imgStr;
    NSInteger timeNUm;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    self.photoView.backgroundColor = [UIColor redColor];
//    self.textView.backgroundColor = [UIColor greenColor];
    
    self.sendButton.enabled = NO;
    userPhotoList = [[NSMutableArray alloc] init];
    self.textView.text = @"";
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.selectedRange = NSMakeRange(0,0);
    self.textView.font = [UIFont systemFontOfSize:16.f];
    self.textView.inputAccessoryView = [self makekeywordBarView];
    [self.view addSubview: self.textView];
    
    //提示内容
    promptLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 8, 100, 19)];
    promptLabel.text = @"我们是首堵...";
    promptLabel.font = [UIFont systemFontOfSize:16];
    promptLabel.textColor = [LuJieCommon UIColorFromRGB:0x999999];
    [self.textView addSubview:promptLabel];

    //键盘工具栏
    self.keywordBarView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    [self.keywordBarView setFrame:CGRectMake(0, self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    [self.view addSubview:self.keywordBarView];
    
    //堵车原因picker
    self.casepicker = [[UIPickerView alloc] init];
    self.casepicker.tag = 0;
    self.casepicker.dataSource = self;
    self.casepicker.delegate = self;
    self.casepicker.showsSelectionIndicator = YES;
    self.ducheCaseButton.inputView = [self casepicker];
    self.ducheCaseButton.inputAccessoryView = [self makepickerBarView];
    
    //堵车事件picker
    //堵车原因picker
    self.timepicker = [[UIPickerView alloc] init];
    self.timepicker.tag = 1;
    self.timepicker.dataSource = self;
    self.timepicker.delegate = self;
    self.timepicker.showsSelectionIndicator = YES;
    self.ducheTimeButton.inputView = [self timepicker];
    self.ducheTimeButton.inputAccessoryView = [self makepickerBarView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma 点击空白地方隐藏键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
    [self.ducheCaseButton resignFirstResponder];
    [self.ducheTimeButton resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)adjustSelection:(UITextView *)textView {
    
    // workaround to UITextView bug, text at the very bottom is slightly cropped by the keyboard
    if ([textView respondsToSelector:@selector(textContainerInset)]) {
        [textView layoutIfNeeded];
        CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
        caretRect.size.height += textView.textContainerInset.bottom;
        [textView scrollRectToVisible:caretRect animated:NO];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    [self adjustSelection:textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    [self adjustSelection:textView];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)TextView {
    [TextView resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        promptLabel.text = @"我们是首堵...";
        self.sendButton.enabled = NO;
    }else{
        promptLabel.text = @"";
        self.sendButton.enabled = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }

    return YES;
}

#pragma 导航按钮事件

- (IBAction)canceAction:(id)sender {
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)sendAction:(id)sender {
    [self.textView resignFirstResponder];
    [self.ducheCaseButton resignFirstResponder];
    [self.ducheTimeButton resignFirstResponder];
    
    if ([self.ducheLable.text length] < 1) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"请选择堵车原因", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        [self.ducheCaseButton becomeFirstResponder];
        return;
    }
    if ([self.timeLable.text length] < 1) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"请选择堵车时间", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        [self.ducheTimeButton becomeFirstResponder];
        return;
    }
    
    //发送数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account": [userDefaults stringForKey:@"userPhone"], @"location": [userDefaults stringForKey:@"userArea"],
                                 @"type": @"2", @"img": [self getImgStr],@"huati":self.textView.text,@"dccase":self.ducheLable.text,@"jgtime":[NSString stringWithFormat:@"%d",(int)timeNUm]};
    [manager POST:@"http://114.215.187.69/citypin/rs/laba/pub" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"发送成功！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion: nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络错误，发送失败！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma 堵车 堵车时间事件
- (IBAction)ducheCaseAction:(id)sender {
    
}

- (IBAction)ducheTime:(id)sender {
    
}

#pragma accessry 键盘工具栏按钮事件
- (IBAction)photoAction:(id)sender {
    
#if 1
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [LuJieCommon UIColorFromRGB:0x37D077];
    appearanceConfig.assetsGroupSelectedImageName = @"checker";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = 3;
    [self presentViewController:picker animated:YES completion:^{}];
}

-(void)doneAction:(id)sender
{
    [self.ducheCaseButton resignFirstResponder];
    if (self.ducheLable.text.length == 0 ) {
        self.ducheLable.text =@"大流量";
    }
}

-(void)doneAction2:(id)sender
{
    [self.ducheTimeButton resignFirstResponder];
    if (self.timeLable.text.length == 0) {
        self.timeLable.text =@"15分钟左右";
    }
}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
//    DLog(@"assets %@",assets);
    for(UIImageView* view in userPhotoList)
    {
        [view removeFromSuperview];
    }
    [userPhotoList removeAllObjects];
    
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake((idx%3)*92+(idx%3+1)*10, 10, 92, 92)];
            //            userImage.image = [img imageByScalingAndCroppingForSize:CGSizeMake(326, 248)];
            userImage.image = [img scaleToSize:CGSizeMake(640, 480)];
            userImage.clipsToBounds = YES;
            userImage.contentMode = UIViewContentModeScaleAspectFill;
            [self.photoView addSubview:userImage];
            [userPhotoList addObject:userImage];
        }];
    }
}

- (void)UzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"目前只允许选择3张图片！"
                                                   delegate:nil
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - make DataSource

- (NSMutableArray *)caseList
{
    if(!caseList) {
        caseList= [[NSMutableArray alloc] init];
        [caseList addObject:@"大流量"];
        [caseList addObject:@"事故"];
        [caseList addObject:@"积水"];
        [caseList addObject:@"信号灯故障"];
        [caseList addObject:@"其他"];
        
    }
    return caseList;
}

- (NSMutableArray *)timeList
{
    if(!timeList) {
        timeList= [[NSMutableArray alloc] init];
        [timeList addObject:@"15分钟左右"];
        [timeList addObject:@"半小时左右"];
        [timeList addObject:@"堵车45分钟左右"];
        [timeList addObject:@"大于1个小时"];
    }
    return timeList;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //    NSLog(@"numberOfRowsInComponent %i", pickerView.tag);
    if (pickerView.tag == 0) {
        return self.caseList.count;
    }
    else {
        return self.timeList.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //        NSLog(@"titleForRow %i", pickerView.tag);
    if (pickerView.tag == 0) {
        return self.caseList[row];
    }
    else {
        return self.timeList[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (pickerView.tag ==0) {
        self.ducheLable.text =[self.casepicker.delegate pickerView:pickerView titleForRow:row forComponent:component];
    } else{
        self.timeLable.text =[self.casepicker.delegate pickerView:pickerView titleForRow:row forComponent:component];
        timeNUm = row;
    }
}

#pragma made keyworad toolbar

-(UIView *)makekeywordBarView
{
    UIView * accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    accessoryView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    UIButton * accphoto = [[UIButton alloc] initWithFrame:CGRectMake(21, 13, 20, 20)];
    [accphoto setBackgroundImage:[UIImage imageNamed:@"keyboard_image"] forState:UIControlStateNormal];
    [accphoto addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchDown];
    [accessoryView addSubview:accphoto];
//    UIButton *  accsharp = [[UIButton alloc] initWithFrame:CGRectMake(83, 13, 20, 20)];
//    [accsharp setBackgroundImage:[UIImage imageNamed:@"keyboard_sharp"] forState:UIControlStateNormal];
//    [accsharp addTarget:self action:@selector(sharpAction:) forControlEvents:UIControlEventTouchDown];
//    [accessoryView addSubview:accsharp];
    
    return accessoryView;
}

-(UIView *)makepickerBarView
{
    UIView * accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    accessoryView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    UIButton * done = [[UIButton alloc] initWithFrame:CGRectMake(accessoryView.bounds.size.width - 60, 10, 52, 30)];
    [done setTitle:@"确定" forState:UIControlStateNormal];
    done.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [done setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchDown];
    [accessoryView addSubview:done];
    
    return accessoryView;
}

-(UIView *)makepickerBarView2
{
    UIView * accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    accessoryView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    UIButton * done = [[UIButton alloc] initWithFrame:CGRectMake(accessoryView.bounds.size.width - 60, 10, 52, 30)];
    [done setTitle:@"确定" forState:UIControlStateNormal];
    done.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [done setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneAction2:) forControlEvents:UIControlEventTouchDown];
    [accessoryView addSubview:done];
    
    return accessoryView;
}

#pragma upyun

-(NSString * )getSaveKey {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    NSDate *d = [NSDate date];
    return [NSString stringWithFormat:@"/%d/%d/%.0f.png",[self getYear:d],[self getMonth:d],[[NSDate date] timeIntervalSince1970]*1000];
    
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    
    /**
     *	@brief	更多方式 参阅 http://wiki.upyun.com/index.php?title=Policy_%E5%86%85%E5%AE%B9%E8%AF%A6%E8%A7%A3
     */
    
}

- (int)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    return (int)year;
}

- (int)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger month = [comps month];
    return (int)month;
}

#pragma 获取图片路径

- (NSString *)getImgStr
{
    imgStr = @"";
    NSData *imgdata;
    if (userPhotoList.count == 0) {
        return imgStr;
    }
    //调用up yun 上传图片接口
    UpYun *uy = [[UpYun alloc] init];
    if (userPhotoList.count == 1) {
        //上传图片
        NSString *photoUrl = [self getSaveKey];
        imgdata = UIImageJPEGRepresentation([[userPhotoList objectAtIndex:0] image], 0.4);
        [uy uploadFile:imgdata saveKey:photoUrl];
        imgStr = [imgStr stringByAppendingString:photoUrl];
    }else
    {
        //多张图片上传
        for (int i=0; i<=userPhotoList.count-2; i++) {
            //上传图片
            NSString *photoUrl = [self getSaveKey];
            imgdata = UIImageJPEGRepresentation([[userPhotoList objectAtIndex:i] image], 0.4);
            [uy uploadFile:imgdata saveKey:photoUrl];
            imgStr = [imgStr stringByAppendingString:photoUrl];
            imgStr = [imgStr stringByAppendingString:@";"];
        }
        //之前没注意，留下的bug 2014-10-6
        NSString *photoUrl = [self getSaveKey];
        imgdata = UIImageJPEGRepresentation([[userPhotoList lastObject] image], 0.4);
        [uy uploadFile:imgdata saveKey:photoUrl];
        imgStr = [imgStr stringByAppendingString:photoUrl];
    }
    return imgStr;
}

@end
