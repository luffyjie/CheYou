//
//  CheYouTuCaoTableViewCell.m
//  CheYou
//
//  Created by lujie on 14-8-28.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouTuCaoTableViewCell.h"

@interface CheYouTuCaoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userPetName;
@property (weak, nonatomic) IBOutlet UILabel *pulishTime;
@property (weak, nonatomic) IBOutlet UILabel *tuCaoTag;
@property (weak, nonatomic) IBOutlet UITextView *tuCaoText;
@property (weak, nonatomic) IBOutlet UIButton *angerButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *xelementButton;

@end

@implementation CheYouTuCaoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
