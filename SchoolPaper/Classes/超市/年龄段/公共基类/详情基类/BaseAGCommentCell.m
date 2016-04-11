//
//  BaseAGCommentCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-12.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGCommentCell.h"

@implementation BaseAGCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.font = FontBold(17);
        _createTime = [UILabel new];
        _createTime.font = Font(15);
        _createTime.textColor = CustomBlack;
        
        self.detailTextLabel.font = Font(15);
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = CustomBlack;
        _rate = [StarRateView new];
        _rate.allowUserInteraction = NO;
        
        [self.contentView addSubview:_createTime];
        [self.contentView addSubview:_rate];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat inset = ScaleH(10);
    self.imageView.frame = CGRectMake(inset, inset, ScaleW(60), ScaleH(60));
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x =  CGRectGetMaxX(self.imageView.frame) + inset;
    textLabelFrame.origin.y = CGRectGetMidY(self.imageView.frame) - self.textLabel.font.lineHeight - inset / 2;
    self.textLabel.frame = textLabelFrame;
    
    
    
    NSString *content = [Base64 textFromBase64String:_datas[@"content"]];
    if (!content.length) {
        content = @"（空）";
    }
    CGSize contentSize = [NSObject getSizeWithText:content font:self.detailTextLabel.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(self.imageView.frame) - inset, MAXFLOAT)];
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + inset, CGRectGetMidY(self.imageView.frame) + inset / 2, contentSize.width, contentSize.height);
    
    if (self.textLabel.font.lineHeight + contentSize.height + inset > CGRectGetHeight(self.imageView.frame)) {
        [_rate setFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + inset, CGRectGetMaxY(self.detailTextLabel.frame) + inset, ScaleW(120), ScaleH(20)) starCount:5];
    }
    else
    {
        [_rate setFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + inset, CGRectGetMaxY(self.imageView.frame) + inset, ScaleW(120), ScaleH(20)) starCount:5];
    }

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:_datas[@"createDate"]];
    NSString *createTime = [NSObject compareCurrentTimeToPastTime:date];
    CGSize createTimeSize = [NSObject getSizeWithText:createTime font:_createTime.font maxSize:CGSizeMake(DeviceW, _createTime.font.lineHeight)];
    _createTime.frame = CGRectMake(DeviceW - CGRectGetMaxX(self.imageView.frame) + inset * 2 - createTimeSize.width, CGRectGetMinY(self.imageView.frame), createTimeSize.width, createTimeSize.height);
    _createTime.text = createTime;
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetMaxX(self.imageView.frame) + inset, 0, 0)];
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    NSString *topImg = [Base64 textFromBase64String:datas[@"userTopimg"]];
    NSString *userName = [Base64 textFromBase64String:datas[@"userName"]];
    NSString *content = [Base64 textFromBase64String:datas[@"content"]];
    if (!content.length) {
        content = @"（空）";
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:datas[@"createDate"]];
    NSString *createTime = [NSObject compareCurrentTimeToPastTime:date];
    _createTime.text = createTime;
    
    CGFloat score = [datas[@"score"] floatValue];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topImg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
    self.textLabel.text = userName;
    self.detailTextLabel.text = content;
    _rate.percentage = score / 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
