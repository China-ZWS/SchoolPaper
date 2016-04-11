//
//  ChatCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-3.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [UIImageView new];
        _backImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backImgView addTarget:self action:@selector(eventWithTouch:) forControlEvents:UIControlEventTouchUpInside];
        _name = [UILabel new];
        _name.font = Font(15);
        _name.textColor = CustomBlack;
        _name.numberOfLines = 0;

        _textLb = [UILabel new];
        _textLb.font = Font(15);
        _textLb.textColor = CustomBlack;
        _textLb.numberOfLines = 0;
        _contentImg = [UIImageView new];
        _contentImg.contentMode = UIViewContentModeScaleAspectFit;
//        _contentImg.userInteractionEnabled = YES;
        
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activity setHidesWhenStopped:YES]; //当旋转结束时隐藏
        _send_status = [UIImageView new];
        
        _soundTime = [UILabel new];
        _soundTime.font = Font(15);
        _soundTime.textColor = CustomBlack;
        _soundTime.numberOfLines = 0;
        _soundTime.textAlignment = NSTextAlignmentCenter;
        
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_backImgView];
        [_backImgView addSubview:_textLb];
        [_backImgView addSubview:_contentImg];
        [self.contentView addSubview:_activity];
        [self.contentView addSubview:_send_status];
        [self.contentView addSubview:_soundTime];

    }
    return self;
}



- (void)setDatas:(id)datas
{

    NSString *type = datas[@"type"];
    
    CGFloat inset = ScaleW(10);
    CGFloat imgInset = ScaleW(60);
    
    NSString *create_id = datas[@"create_id"];
    NSString *my_id = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
    NSString *topImg = datas[@"user_top"];
    NSString *send_status = datas[@"send_status"];
    NSString *name = datas[@"user_name"];
    NSString *msg_length = [datas[@"msg_length"] stringByAppendingString:@"\""];
    id msg = datas[@"message"];
    
    
    CGSize msgSize = CGSizeZero;
    if ([type isEqualToString:@"TXT"])
    {
        _textLb.hidden = NO;
        _soundTime.hidden = YES;
        _contentImg.hidden = YES;
        msgSize = [NSObject getSizeWithText:msg font:_textLb.font maxSize:CGSizeMake(DeviceW - inset * 9 - imgInset, MAXFLOAT)];
    }
    else if ([type isEqualToString:@"IMG"])
    {
        _textLb.hidden = YES;
        _soundTime.hidden = YES;
        _contentImg.hidden = NO;
        msgSize = CGSizeMake(ScaleW(150), ScaleH(150));
    }
    else if ([type isEqualToString:@"AUDIO"])
    {
        _textLb.hidden = YES;
        _contentImg.hidden = NO;
        _soundTime.hidden = NO;
        msgSize = [NSObject getSizeWithText:msg_length font:_soundTime.font maxSize:CGSizeMake(40, _soundTime.font.lineHeight)];
    }
    

    UIImage *bakcImage = nil;
    
    if ([create_id isEqualToString:my_id])
    {
        _name.hidden = YES;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:[Infomation readInfo][@"top_image"]]] placeholderImage:[UIImage imageNamed:@"userguide_avatar_icon.png"]];
        _headImageView.frame = CGRectMake(DeviceW - inset - imgInset, inset + inset / 2, imgInset, imgInset);
        _backImgView.frame = CGRectMake(CGRectGetMinX(_headImageView.frame) - inset - msgSize.width - inset * 2, CGRectGetMinY(_headImageView.frame), msgSize.width + inset * 2, msgSize.height + inset * 2);
        
        bakcImage = [UIImage imageNamed:@"msg_sendto_done_bg_nor.png"];
        CGFloat top = 22; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 15; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        bakcImage = [bakcImage resizableImageWithCapInsets:insets ];
        
        if ([type isEqualToString:@"TXT"])
        {
            _textLb.frame = CGRectMake(inset * 2 / 3, inset, msgSize.width, msgSize.height);
            _textLb.text = msg;
            
            _activity.center = CGPointMake(CGRectGetMinX(_backImgView.frame) - ScaleW(20), CGRectGetMidY(_backImgView.frame));
        }
        else if ([type isEqualToString:@"IMG"])
        {
            _contentImg.frame = CGRectMake(inset * 2 / 3, inset, msgSize.width, msgSize.height);
            UIImage *myCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:msg];
            _contentImg.image = myCachedImage;
            _activity.center = CGPointMake(CGRectGetMinX(_backImgView.frame) - ScaleW(20), CGRectGetMidY(_backImgView.frame));
        }
        else if ([type isEqualToString:@"AUDIO"])
        {
            _soundTime.frame = CGRectMake(CGRectGetMinX(_backImgView.frame) - ScaleW(5) - msgSize.width, CGRectGetMidY(_backImgView.frame) - msgSize.height / 2, msgSize.width, msgSize.height);
            _soundTime.text = msg_length;
            _activity.center = CGPointMake(CGRectGetMinX(_soundTime.frame) - ScaleW(20), CGRectGetMidY(_backImgView.frame));
            UIImage *soundImg = [UIImage imageNamed:@"record_me_normal.png"];
            _contentImg.frame = CGRectMake(inset * 2 / 3, (CGRectGetHeight(_backImgView.frame) - soundImg.size.height) / 2, soundImg.size.width, soundImg.size.height);
            _contentImg.image = soundImg;
        }
        
    }
    else
    {
        _name.hidden = NO;
 
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:topImg] placeholderImage:[UIImage imageNamed:@"userguide_avatar_icon.png"]];
        _headImageView.frame = CGRectMake(inset, inset, imgInset, imgInset);
        _name.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + inset, inset, 100, _name.font.lineHeight);
        
        _backImgView.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + inset, CGRectGetMaxY(_name.frame) + inset / 2, msgSize.width + inset * 2, msgSize.height + inset * 2);

        bakcImage = [UIImage imageNamed:@"msg_sendfrom_done_bg_nor.png"];
        CGFloat top = 22; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 15; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        bakcImage = [bakcImage resizableImageWithCapInsets:insets ];
        
        if ([type isEqualToString:@"TXT"])
        {
            _textLb.frame = CGRectMake(inset * 2 / 3 * 2, inset, msgSize.width, msgSize.height);
            _textLb.text = msg;
            _activity.center = CGPointMake(CGRectGetMaxX(_backImgView.frame) + ScaleW(20), CGRectGetMidY(_backImgView.frame));
        }
        else if ([type isEqualToString:@"IMG"])
        {
            _contentImg.frame = CGRectMake(inset * 2 / 3 * 2, inset, msgSize.width, msgSize.height);
            [_contentImg sd_setImageWithURL:[NSURL URLWithString:msg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
            _activity.center = CGPointMake(CGRectGetMaxX(_backImgView.frame) + ScaleW(20), CGRectGetMidY(_backImgView.frame));
        }
        else if ([type isEqualToString:@"AUDIO"])
        {
            _soundTime.frame = CGRectMake(CGRectGetMaxX(_backImgView.frame) + ScaleW(5), CGRectGetMidY(_backImgView.frame) - msgSize.height / 2, msgSize.width, msgSize.height);
            _soundTime.text = msg_length;

            _activity.center = CGPointMake(CGRectGetMaxX(_soundTime.frame) + ScaleW(20), CGRectGetMidY(_backImgView.frame));
            UIImage *soundImg = [UIImage imageNamed:@"record_other_normal.png"];
            _contentImg.frame = CGRectMake(inset * 2 / 3 , (CGRectGetHeight(_backImgView.frame) - soundImg.size.height) / 2, soundImg.size.width, soundImg.size.height);
            _contentImg.image = soundImg;
        }
        
        
        _name.text = name;
    }
    
    
    [_backImgView setBackgroundImage:bakcImage forState:UIControlStateNormal];;
    _backImgView.bindingInfo = datas;
    
    UIImage *send_statusImg = [UIImage imageNamed:@"msg_state_fail_resend.png"];
    _send_status.frame = _activity.frame;
    _send_status.image = send_statusImg;
    
    if ([send_status integerValue] == 0)
    {
        _send_status.hidden = YES;
        [_activity stopAnimating];
    }
    else if ([send_status integerValue] == 1)
    {
        _send_status.hidden = YES;
        [_activity startAnimating];
    }
    else if ([send_status integerValue] == 2)
    {
        _send_status.hidden = NO;
        [_activity stopAnimating];
    }

    
}

- (void)layoutWithTXT
{
    
}

- (void)layoutWithIMG
{

}


- (void)eventWithTouch:(UIButton *)button
{
    NSMutableDictionary *datas = button.bindingInfo;
    NSString *send_status = datas[@"send_status"];
    NSString *type = datas[@"type"];
    
    if ([send_status integerValue] == 2)
    {
        [_delegate reSend:datas];
    }
    else if ([send_status integerValue] == 1)
    {
        
        return;
    }
    else
    {
        if ([type isEqualToString:@"TXT"])
        {
            NSLog(@"TXT");
        }
        else if ([type isEqualToString:@"IMG"])
        {
            NSLog(@"IMG");
            
        }
        else if ([type isEqualToString:@"AUDIO"])
        {
            [_delegate playSound:datas[@"message"]];
            NSLog(@"AUDIO");
        }
    }
    
    

    

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
