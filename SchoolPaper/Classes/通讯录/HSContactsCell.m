//
//  HSContactsCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HSContactsCell.h"

@implementation HSContactsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.imageView.frame = CGRectMake(ScaleX(15), (ScaleH(60) - ScaleH(45)) / 2, ScaleW(45), ScaleH(45));
        self.textLabel.font = Font(17);
        self.textLabel.textColor = CustomBlue;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setIndexPath:(NSIndexPath *)indexPath keys:(NSArray *)keys teachers:(NSArray *)teachers students:(NSDictionary *)students
{
    
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            self.imageView.image = [UIImage imageNamed:@"searadd_icon.png"];
            self.textLabel.text = @"新增";
        }
        else
        {
            self.imageView.image = [UIImage imageNamed:@"icon_group.png"];
            self.textLabel.text = [NSString stringWithFormat:@"%@%@群",[Base64 textFromBase64String:[Infomation readInfo][@"grade"]],[Base64 textFromBase64String:[Infomation readInfo][@"classCode"]]];
        }
    }
    else if (indexPath.section == 1)
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:teachers[indexPath.row][@"topImg"] ]] placeholderImage:[UIImage imageNamed:@"icon_head.png"]];
        self.textLabel.text = [NSString stringWithFormat:@"%@（%@）",[Base64 textFromBase64String:teachers[indexPath.row][@"tacName"]],[Base64 textFromBase64String:teachers[indexPath.row][@"teacSubject"]]];
    }
    else
    {
        NSString *key=[keys objectAtIndex:indexPath.section - 2];
        //获取键所对应的值（数组）。
        NSArray *row=[students objectForKey:key];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:row[indexPath.row][@"topImg"] ]] placeholderImage:[UIImage imageNamed:@"icon_head.png"]];
        self.textLabel.text = [Base64 textFromBase64String:row[indexPath.row][@"stuName"]];
    }
    
}

- (void)setDatas:(id)datas
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:datas[@"topImg"] ]] placeholderImage:[UIImage imageNamed:@"icon_head.png"]];
    if (datas[@"tacName"]) {
        self.textLabel.text = [NSString stringWithFormat:@"%@（%@）",[Base64 textFromBase64String:datas[@"tacName"]],[Base64 textFromBase64String:datas[@"teacSubject"]]];
    }
    else
    {
        self.textLabel.text = [Base64 textFromBase64String:datas[@"stuName"]];
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
