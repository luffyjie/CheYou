//
//  CheYouFaXianViewController.m
//  CheYou
//
//  Created by lujie on 14-8-30.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouFaXianViewController.h"
#import "LuJieCommon.h"
#import "AFNetworking.h"
#import "UpYun.h"
#import "UIImageExt.h"
#import "PickerItem.h"

@interface CheYouFaXianViewController ()
@property (weak, nonatomic) IBOutlet UIView *keyboarbarView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *photoView;

@end

@implementation CheYouFaXianViewController

{
    UIButton *accphoto;
    UIButton *accsharp;
    UIButton *accwink;
    UIView *accessoryView;
    UILabel *promptLabel;
    NSMutableArray *userPhotoList;
    NSString *imgStr;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //    self.scrollView.backgroundColor=[UIColor redColor];
    //    self.photoView.backgroundColor = [UIColor blueColor];
    //    self.textView.backgroundColor = [UIColor greenColor];
    self.sendButton.enabled = NO;
    userPhotoList = [[NSMutableArray alloc] init];
    
    self.textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 166)];
    self.textView.text = @"";
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.selectedRange = NSMakeRange(0,0);
    self.textView.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview: self.textView];
    self.textView.delegate = self;
    
    self.photoView = [[UIView alloc] initWithFrame: CGRectMake(0, self.textView.bounds.size.height, self.view.bounds.size.width, 100)];
    [self.view addSubview:self.photoView];
    
    //提示内容
    promptLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 8, 180, 19)];
    promptLabel.text = @"看我发现了什么";
    promptLabel.font = [UIFont systemFontOfSize:16.f];
    promptLabel.textColor = [LuJieCommon UIColorFromRGB:0x999999];
    [self.textView addSubview:promptLabel];
    
    //键盘工具栏
    self.keyboarbarView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    
    //底部工具栏
    accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    accessoryView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    UIImageView *cameraview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboard_image"]];
    cameraview.frame = CGRectMake(21, 13, 25, 19);
    [accessoryView addSubview:cameraview];
    accphoto = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 60, 40)];
//    accphoto.backgroundColor = [UIColor redColor];
//    [accphoto setBackgroundImage:[UIImage imageNamed:@"keyboard_image"] forState:UIControlStateNormal];
    [accphoto addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchDown];
    [accessoryView addSubview:accphoto];
    [self.view addSubview:accessoryView];
    //注册用户发表了新喇叭的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePhoto:)
                                                 name:@"deletePhotoNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma 点击空白地方隐藏键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    
    // note: you can create the accessory view programmatically (in code), or from the storyboard
    if (self.textView.inputAccessoryView == nil) {
        
        self.textView.inputAccessoryView = self.keyboarbarView;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    [aTextView resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        accessoryView.hidden = NO;
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        promptLabel.text = @"看我发现了什么";
        self.sendButton.enabled = NO;
    }else{
        promptLabel.text = @"";
        self.sendButton.enabled = YES;
    }
}

#pragma 导航按钮事件

- (IBAction)cancelAction:(id)sender {
    [self.textView resignFirstResponder];    
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)sendAction:(id)sender {
    self.sendButton.enabled = NO;
    [self.textView resignFirstResponder];
    //发送数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account": [userDefaults stringForKey:@"userPhone"], @"location": [userDefaults stringForKey:@"userArea"],
                                 @"type": @"3", @"img": [self getImgStr],@"huati":self.textView.text};
    [manager POST:@"http://114.215.187.69/citypin/rs/laba/pub" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        NSString *title = NSLocalizedString(@"提示", nil);
//        NSString *message = NSLocalizedString(@"发送成功！", nil);
//        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
//        [alert show];
        //向通知中心发送消息
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pbNewNotification"
         object:nil
         userInfo:nil];
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

#pragma accessry 键盘工具栏按钮事件

- (IBAction)photoAction:(id)sender {
    
#if 1
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [LuJieCommon UIColorFromRGB:0x354b60];
    appearanceConfig.assetsGroupSelectedImageName = @"checker";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = 3;
    [self presentViewController:picker animated:YES completion:^{}];
}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for(UIImageView* view in userPhotoList)
    {
        [view removeFromSuperview];
    }
    [userPhotoList removeAllObjects];
    
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        for (int i = 0; i < assets.count; i++) {
            ALAsset *asset = assets[i];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage  *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    PickerItem *pickeritem = [[PickerItem alloc] initWithimage:i toimg: image frame:CGRectMake((i%3)*92+(i%3+1)*10, (i/3)*102, 92, 92)];
                    [self.photoView addSubview:pickeritem];
                    [userPhotoList addObject:pickeritem];
                });
            });
        }
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
        imgdata = UIImageJPEGRepresentation([[[userPhotoList objectAtIndex:0] imageView] image], 0.4);
        [uy uploadFile:imgdata saveKey:photoUrl];
        imgStr = [imgStr stringByAppendingString:photoUrl];
    }else
    {
        //多张图片上传
        for (int i=0; i<=userPhotoList.count-2; i++) {
            //上传图片
            NSString *photoUrl = [self getSaveKey];
            imgdata = UIImageJPEGRepresentation([[[userPhotoList objectAtIndex:i] imageView] image], 0.4);
            [uy uploadFile:imgdata saveKey:photoUrl];
            imgStr = [imgStr stringByAppendingString:photoUrl];
            imgStr = [imgStr stringByAppendingString:@";"];
        }
        //之前没注意，留下的bug 2014-10-6
        NSString *photoUrl = [self getSaveKey];
        imgdata = UIImageJPEGRepresentation([[[userPhotoList lastObject] imageView] image], 0.4);
        [uy uploadFile:imgdata saveKey:photoUrl];
        imgStr = [imgStr stringByAppendingString:photoUrl];
    }
    return imgStr;
}

#pragma 处理删除选择的图片
- (void)deletePhoto:(NSNotification*)notification
{
    //接受notification的userInfo，可以把参数存进此变量
    NSDictionary *theData = [notification userInfo];
    NSInteger imgid = [[theData objectForKey:@"imgid"] integerValue];
    NSArray *list = [NSArray arrayWithArray: userPhotoList];
    for (PickerItem *pick in list) {
        if (pick.imgid == imgid) {
            [userPhotoList removeObject:pick];
        }
    }
    for (int i=0; i<userPhotoList.count; i++) {
        [[userPhotoList objectAtIndex:i] setFrame:CGRectMake((i%3)*92+(i%3+1)*10, (i/3)*102, 92, 92)];
        [self.photoView addSubview:userPhotoList[i]];
    }
}

@end
