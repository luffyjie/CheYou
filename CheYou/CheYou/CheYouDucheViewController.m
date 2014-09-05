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

@interface CheYouDucheViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (strong, nonatomic) IBOutlet UIView *keywordBarView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet PRButton *ducheCaseButton;
@property (weak, nonatomic) IBOutlet PRButton *ducheTimeButton;

@property (strong, nonatomic) UIPickerView *casepicker;

@end

@implementation CheYouDucheViewController

{
    UIButton *accphoto;
    UIButton *accsharp;
    UIButton *accwink;
    UIView *accessoryView;
    UILabel *promptLabel;
    NSMutableArray *userPhotoList;
    NSMutableArray *caseList;
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
    [self.view addSubview: self.textView];
    //提示内容
    promptLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 8, 100, 19)];
    promptLabel.text = @"我们是首堵...";
    promptLabel.font = [UIFont systemFontOfSize:16];
    promptLabel.textColor = [LuJieCommon UIColorFromRGB:0x999999];
    [self.textView addSubview:promptLabel];

    //键盘工具栏
    self.keywordBarView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    self.keywordBarView.frame = CGRectMake(0, self.view.bounds.size.height + 300, self.view.bounds.size.height, 46);
    [self.view addSubview:self.keywordBarView];
    
    //堵车原因picker
    self.casepicker = [[UIPickerView alloc] init];
    self.casepicker.tag = 0;
    self.casepicker.dataSource = self;
    self.casepicker.delegate = self;
    self.casepicker.showsSelectionIndicator = YES;
    self.ducheCaseButton.inputView = [self casepicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Listen for will show/hide notifications
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
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
        accessoryView.hidden = NO;
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }

    return YES;
}

#pragma mark - forKeyboard bar animation helpers

// Helper method for moving the toolbar frame based on user action
- (void)moveToolBarUp:(BOOL)up forKeyboardNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (up) {
        [self.keywordBarView setFrame:CGRectMake(0, self.view.bounds.size.height - keyboardFrame.size.height - 46, self.view.bounds.size.width, 46)];
    }else{
        [self.keywordBarView setFrame:CGRectMake(0, self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    }
    [UIView commitAnimations];
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // move the toolbar frame up as keyboard animates into view
    [self moveToolBarUp:YES forKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // move the toolbar frame down as keyboard animates into view
    [self moveToolBarUp:NO forKeyboardNotification:notification];
}

#pragma 导航按钮事件

- (IBAction)canceAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)sendAction:(id)sender {
    
    [self.textView resignFirstResponder];
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
- (IBAction)winkAction:(id)sender {

}

- (IBAction)sharpAction:(id)sender {

}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    DLog(@"assets %@",assets);
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
            userImage.image = img;
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
        return self.caseList.count;
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
        return self.caseList[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%@",[self.casepicker.delegate pickerView:pickerView titleForRow:row forComponent:component]);
    if (pickerView.tag ==0) {
//        self.ducheCaseButton.text = [self.casepicker.delegate pickerView:pickerView titleForRow:row forComponent:component];
    } else{
//        self.ducheCaseButton.text = [self.casepicker.delegate pickerView:pickerView titleForRow:row forComponent:component];
    }
}

@end
