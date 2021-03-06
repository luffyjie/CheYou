//
//  CheYouSetInfoViewController.m
//  CheYou
//
//  Created by lujie on 14-9-20.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouSetInfoViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PRButton.h"
#import "LuJieCommon.h"
#import "UpYun.h"
#import "AFNetworking.h"

#define ORIGINAL_MAX_WIDTH 360.0f

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface CheYouSetInfoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet PRButton *areaText;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishButton;
@property (weak, nonatomic) IBOutlet UITextField *aicheText;

@end

@implementation CheYouSetInfoViewController

{
    UIPickerView *areapicker;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;
    NSData *imgData;
    NSString *chooseArea;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取地区数据
    [self getCity];
    areapicker = [[UIPickerView alloc] init];
    areapicker.dataSource = self;
    areapicker.delegate = self;
    areapicker.showsSelectionIndicator = YES;
    [areapicker selectRow: 0 inComponent: 0 animated: YES];
    self.areaText.inputView = areapicker;
    self.areaText.inputAccessoryView = [self makeareaBarView];
    selectedProvince = [province objectAtIndex: 0];
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    backButton.image = [UIImage imageNamed:@"back"];
    [self.navigationItem setLeftBarButtonItem:backButton];
    // Do any additional setup after loading the view.
    //生成圆脚图片
    [self.photoView.layer setCornerRadius:CGRectGetHeight([self.photoView bounds]) / 2];
    self.photoView.layer.masksToBounds = YES;
    //昵称
    self.nameText.delegate = self;
    self.nameText.returnKeyType = UIReturnKeyDone;
    self.nameText.tag = 1;
    //爱车
    self.aicheText.delegate = self;
    self.aicheText.returnKeyType = UIReturnKeyDone;
    self.aicheText.tag = 2;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.areaText resignFirstResponder];
}

#pragma 获取省市数据
- (void)getCity
{
    NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
	areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
	NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
}

#pragma UITextFeild 委托

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        if (textField.tag ==1) {
            [self.nameText resignFirstResponder];
        }else{
            [self.aicheText resignFirstResponder];
        }
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    return YES;
}


#pragma 导航按钮

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishAction:(id)sender {
    //验证昵称
    NSString *nkname = [self.nameText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (nkname.length <1) {
            NSString *title = NSLocalizedString(@"提示", nil);
            NSString *message = NSLocalizedString(@"昵称不能为空", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            [alert show];
            [self.nameText becomeFirstResponder];
            return;
        }
    //验证爱车
    NSString *userAiche = [self.aicheText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (userAiche.length <1) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"爱车不能为空", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        [self.aicheText becomeFirstResponder];
        return;
    }
    //验证地区
    if (self.areaLabel.text.length <1) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"地区不能为空", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        [self.areaText becomeFirstResponder];
        return;
    }
    //上传图片
    UpYun *uy = [[UpYun alloc] init];
    NSString *photoUrl = [self getSaveKey];
    if (!imgData) {
        imgData = UIImageJPEGRepresentation(self.photoView.image, 0.4);
    }
    [uy uploadFile:imgData saveKey:photoUrl];
    self.finishButton.enabled = NO;
    //注册用户
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account":self.phoneNum, @"passwd":self.pwd,
                                 @"phone":self.phoneNum, @"nkname":nkname,
                                 @"hpic":photoUrl, @"location":chooseArea,@"vehtype":userAiche};
    [manager POST:@"http://114.215.187.69/citypin/rs/user/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSString *result = [responseObject objectForKey:@"r"];
        if ([result integerValue] == 1) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //更新本地用户数据
                [userDefaults setObject:self.phoneNum forKey:@"userPhone"];
                [userDefaults setObject:self.pwd forKey:@"userPwd" ];
                [userDefaults setObject:nkname forKey:@"userName"];
                [userDefaults setObject:chooseArea forKey:@"userArea"];
                [userDefaults setObject:photoUrl forKey:@"photoUrl"];
                [userDefaults setObject:userAiche forKey:@"userAiche"];
                //设置用户登录状态
                [userDefaults setInteger:2 forKey:@"userOut"];
                //同步本地数据
                [userDefaults synchronize];
                [self performSegueWithIdentifier:@"register_home_segue" sender:self];
                return ;
            }
        if (msg) {
                //假如已经注册，则更新用户
            [self updatePwd:nkname urlTo:photoUrl aicheTo:userAiche];
            return;
        }
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络异常，注册失败", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络异常，注册失败", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        self.finishButton.enabled = YES;
    }];
}

- (void)updatePwd:(NSString *)nkname urlTo:(NSString *)photoUrl aicheTo:(NSString *)userAiche
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account":self.phoneNum, @"passwd":self.pwd,
                                 @"phone":self.phoneNum, @"nkname":nkname,
                                 @"hpic":photoUrl, @"location":chooseArea,@"vehtype":userAiche};
    [manager POST:@"http://114.215.187.69/citypin/rs/user/update" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"r"];
        if ([result integerValue] == 1) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //更新本地用户数据
            [userDefaults setObject:self.phoneNum forKey:@"userPhone"];
            [userDefaults setObject:self.pwd forKey:@"userPwd" ];
            [userDefaults setObject:nkname forKey:@"userName"];
            [userDefaults setObject:chooseArea forKey:@"userArea"];
            [userDefaults setObject:photoUrl forKey:@"photoUrl"];
            [userDefaults setObject:userAiche forKey:@"userAiche"];
            //设置用户登录状态
            [userDefaults setInteger:2 forKey:@"userOut"];
            [userDefaults synchronize];
            [self performSegueWithIdentifier:@"register_home_segue" sender:self];
            return ;
        }
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络异常，注册失败", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"网络异常，注册失败", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        self.finishButton.enabled = YES;
    }];
}

#pragma 个人设置

- (IBAction)photoButton:(id)sender {
    [self editPortrait];
}

#pragma 弹出选择图片提示

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.photoView.image = editedImage;
    imgData = UIImageJPEGRepresentation(editedImage, 0.4);
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
//                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
//                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        city = [[NSArray alloc] initWithArray: array];
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [areapicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [areapicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [areapicker reloadComponent: CITY_COMPONENT];
        [areapicker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [areapicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [areapicker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:18];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:18];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:18];
    }
    
    return myView;
}

#pragma 地区确定bar
-(UIView *)makeareaBarView
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

-(void)doneAction:(id)sender
{
    [self.areaText resignFirstResponder];
    NSInteger provinceIndex = [areapicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [areapicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [areapicker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    self.areaLabel.text = [NSString stringWithFormat: @"%@-%@-%@", provinceStr, cityStr, districtStr];
    chooseArea = [NSString stringWithFormat: @"%@-%@", cityStr, districtStr];
}

#pragma upyun

-(NSString * )getSaveKey {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    NSDate *d = [NSDate date];
    return [NSString stringWithFormat:@"/%d/%d/%.0f.png",[self getYear:d],[self getMonth:d],[[NSDate date] timeIntervalSince1970]];
    
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

@end
