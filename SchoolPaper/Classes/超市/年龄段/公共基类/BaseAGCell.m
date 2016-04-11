//
//  BaseAGCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGCell.h"

@implementation BaseAGCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (([super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        _title = [UILabel new];
        _title.font = FontBold(17);
        _title.textColor = [UIColor blackColor];
        
        _type = [UILabel new];
        _type.font = Font(15);
        _type.textColor = [UIColor whiteColor];
        _type.backgroundColor = RGBA(240, 150, 52, 1);
        _type.textAlignment = NSTextAlignmentCenter;
        
        _level = [UILabel new];
        _level.font = FontBold(17);
        _level.textColor = [UIColor whiteColor];
        _level.backgroundColor = RGBA(114, 192, 165, 1);
        _level.textAlignment = NSTextAlignmentCenter;
        
        _useCount = [UILabel new];
        _useCount.font = Font(15);
        _useCount.textColor = CustomBlack;
        
        _price = [UILabel new];
        _price.font = Font(15);
        _price.textColor = CustomBlack;
        
        _contentLb = [UILabel new];
        _contentLb.font = Font(15);
        _contentLb.textColor = CustomBlack;
        _contentLb.numberOfLines = 0;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_type];
        [self.contentView addSubview:_level];
        [self.contentView addSubview:_useCount];
        [self.contentView addSubview:_price];
        [self.contentView addSubview:_contentLb];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat inset = ScaleW(10);
    
    _headImageView.frame = CGRectMake(kDefaultInset.left + inset, kDefaultInset.top + inset, ScaleW(70), ScaleH(70));
    
//    标题
    CGFloat titleMinY = CGRectGetMinY(_headImageView.frame) + (CGRectGetHeight(_headImageView.frame) - _title.font.lineHeight - (_level.font.lineHeight + inset) - inset) / 2;
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + inset,titleMinY, DeviceW - CGRectGetMaxX(_headImageView.frame) - kDefaultInset.right - inset * 2 - ScaleW(50), _title.font.lineHeight);
//   类型
    _type.frame = CGRectMake(DeviceW - kDefaultInset.right - inset - ScaleW(50), CGRectGetMinY(_headImageView.frame), ScaleW(50), _type.font.lineHeight + inset / 2);
   
//   优还是正
    _level.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + inset, CGRectGetMaxY(_title.frame) + inset, _level.font.lineHeight + inset , _level.font.lineHeight + inset );
    
//   默认多少次
    NSString *useCount = [NSString stringWithFormat:@"%@次默认",[_datas[@"useCount"] stringValue]];
    CGSize useCountSize = [NSObject getSizeWithText:useCount font:_useCount.font maxSize:CGSizeMake(DeviceW, _useCount.font.lineHeight)];
    _useCount.frame = CGRectMake(CGRectGetMaxX(_level.frame) + inset, CGRectGetMinY(_level.frame) + (CGRectGetHeight(_level.frame) - useCountSize.height) / 2, useCountSize.width, useCountSize.height);
    
//   价格
    _price.frame = CGRectMake(CGRectGetMaxX(_useCount.frame) + inset, CGRectGetMinY(_useCount.frame), 50, _price.font.lineHeight);

//    内容
    NSString *tipContent = [Base64 textFromBase64String:_datas[@"tipContent"]];
    CGSize tipContentSize = [NSObject getSizeWithText:tipContent font:_contentLb.font maxSize:CGSizeMake(DeviceW - CGRectGetMinX(_level.frame) - kDefaultInset.right - inset, MAXFLOAT)];
    CGFloat tipContentHeight = 0;
    if (tipContentSize.height < _contentLb.font.lineHeight * 3) {
        tipContentHeight = tipContentSize.height;
    }
    else
    {
        tipContentHeight = _contentLb.font.lineHeight * 3;
    }
    _contentLb.frame = CGRectMake(CGRectGetMinX(_level.frame), CGRectGetMaxY(_headImageView.frame) + inset, DeviceW - CGRectGetMinX(_level.frame) - kDefaultInset.right - inset, tipContentHeight);
}

- (void)drawRect:(CGRect)rect
{
    [self drawWithChamferOfRectangle:rect inset:kDefaultInset radius:3 lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    BOOL isFree = [datas[@"isFree"] boolValue];
    NSString *level = datas[@"level"];
    NSString *name = [Base64 textFromBase64String:datas[@"name"]];
    NSString *price = [datas[@"price"] stringValue];
//    NSString *resourceUrl = datas[@"resourceUrl"];
//    NSString *score = [datas[@"score"] stringValue];
    NSString *tipContent = [Base64 textFromBase64String:datas[@"tipContent"]];
    NSString *type = datas[@"type"];
    NSString *useCount = [datas[@"useCount"] stringValue];
    NSString *viewImg = [Base64 textFromBase64String:datas[@"viewImg"]];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:viewImg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];  
    _title.text = name;
    
    if ([type isEqualToString:@"AUDIO"])
    {
        _type.text = @"收听";
        _useCount.text = [NSString stringWithFormat:@"%@次收听",useCount];
    }
    else if ([type isEqualToString:@"VIDEO"])
    {
        _type.text = @"播放";
        _useCount.text = [NSString stringWithFormat:@"%@次观看",useCount];
    }
    else if ([type isEqualToString:@"DOCUMENT"])
    {
        _type.text = @"阅读";
        _useCount.text = [NSString stringWithFormat:@"%@次阅读",useCount];
    }
    
    if ([level isEqualToString:@"Y"]) {
        _level.text = @"优";
    }
    else if ([level isEqualToString:@"Z"])
    {
        _level.text = @"正";
    }
    
    if (isFree) {
        _price.text = @"免费";
    }
    else
    {
        _price.text = [price stringByAppendingString:@"元"];
    }
    
    _contentLb.text = tipContent;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
