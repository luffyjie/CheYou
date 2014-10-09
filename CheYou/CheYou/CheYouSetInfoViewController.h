//
//  CheYouSetInfoViewController.h
//  CheYou
//
//  Created by lujie on 14-9-20.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheYouSetInfoViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *pwd;

@end
