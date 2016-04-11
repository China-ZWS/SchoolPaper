//
//  HSSearchCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HSSearchCell.h"

@implementation HSSearchCell

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(ScaleX(15), ScaleY(60) - .3) end:CGPointMake(DeviceW, ScaleY(60) - .3) lineColor:CustomGray lineWidth:.3];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScaleX(15), (ScaleH(60) - ScaleH(45)) / 2, ScaleW(45), ScaleH(45))];
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), 0, DeviceW - (CGRectGetMaxX(_headImageView.frame) + ScaleW(15)), ScaleW(60))];
        _name.textColor = CustomBlue;
        _name.font = Font(17);
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_name];
    }
    return self;
}

- (void)setDatas:(id)datas indexPath:(NSIndexPath *)indexPath;
{
    if ([datas[@"key"] isEqualToString:@"老师"])
    {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:datas[@"datas"][indexPath.row][@"topImg"] ]] placeholderImage:[UIImage imageNamed:@"icon_head.png"]];
        _name.text = [NSString stringWithFormat:@"%@（%@）",[Base64 textFromBase64String:datas[@"datas"][indexPath.row][@"tacName"]],[Base64 textFromBase64String:datas[@"datas"][indexPath.row][@"teacSubject"]]];
    }
    else
    {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:datas[@"datas"][indexPath.row][@"topImg"] ]] placeholderImage:[UIImage imageNamed:@"icon_head.png"]];
        _name.text = [Base64 textFromBase64String:datas[@"datas"][indexPath.row][@"stuName"]];
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
