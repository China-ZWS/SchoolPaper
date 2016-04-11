//
//  MineCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "MineCell.h"
@implementation MineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        _name = [UILabel new];
        
        [self.contentView addSubview:_headImageView];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}

- (void)dic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath rowNum:(NSInteger)rowNum;
{
    
    _indexPath = indexPath;
    _rowNum = rowNum;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScaleX(15), ScaleY(15), ScaleW(60), ScaleH(60))];;
            headImageView.tag = 10;
            headImageView.layer.cornerRadius = CGRectGetWidth(headImageView.frame) / 2;
            headImageView.layer.masksToBounds = YES;
            headImageView.layer.borderWidth = 2.0;
            headImageView.layer.borderColor = [UIColor whiteColor].CGColor;

            [headImageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:dic[@"top_image"] ]] placeholderImage:[UIImage imageNamed:@"pTop.png"]];
            [self.contentView addSubview:headImageView];

            
            NSString *name = [Base64 textFromBase64String:dic[@"name"]];
            NSString *idStr = [Base64 textFromBase64String:dic[@"mobileTag"]];
            
            UILabel *nameLb = [UILabel new];
            nameLb.font = Font(20);
            nameLb.text = name;
            nameLb.textColor = RGBA(23, 103, 223, 1);
            [nameLb sizeToFit];
            [self.contentView addSubview:nameLb];
            
            UILabel *idLb = [UILabel new];
            idLb.font = Font(17);
            idLb.text = idStr;
            [idLb sizeToFit];
            [self.contentView addSubview:idLb];
            
            
            UILabel *idStrLb = [UILabel new];
            [self.contentView addSubview:idStrLb];
            
            CGFloat allHeight = CGRectGetHeight(nameLb.frame) + ScaleH(5) + CGRectGetHeight(idLb.frame);
            
            CGFloat name_minY = CGRectGetMinY(headImageView.frame) + (CGRectGetHeight(headImageView.frame) - allHeight) / 2;
            CGFloat id_minY = name_minY + CGRectGetHeight(nameLb.frame) + ScaleH(5);

            CGRect nameRect = nameLb.frame;
            nameRect.origin = CGPointMake(ScaleX(15) + CGRectGetMaxX(headImageView.frame), name_minY);
            nameLb.frame = nameRect;
            
            CGRect idRect = idLb.frame;
            idRect.origin = CGPointMake(ScaleX(15) + CGRectGetMaxX(headImageView.frame), id_minY);
            idLb.frame = idRect;
        }
        else
        {
            _title = [UILabel new];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"个性签名：%@",[Base64 textFromBase64String:dic[@"autograph"]]]];
            
            [title addAttribute:NSForegroundColorAttributeName value:RGBA(23, 103, 223, 1) range:NSMakeRange(0,@"个性签名：".length)];
            [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(@"个性签名：".length, title.length - @"个性签名：".length)];
            [title addAttribute:NSFontAttributeName value:Font(17) range:NSMakeRange(0, title.length)];
            _title.attributedText = title;
            [_title sizeToFit];
            _title.center = CGPointMake(CGRectGetWidth(_title.frame) / 2 + ScaleX(15), (ScaleH(60) - CGRectGetHeight(_title.frame)) / 2 + CGRectGetHeight(_title.frame) / 2);
            [self.contentView addSubview:_title];
        }
        
    }
    else
    {
        _title = [UILabel new];
        _title.font = Font(17);
        _title.textColor = RGBA(23, 103, 223, 1);
        _title.text =  dic[@"title"];
        [_title sizeToFit];
        _title.center = CGPointMake(CGRectGetWidth(_title.frame) / 2 + ScaleX(15), (ScaleH(60) - CGRectGetHeight(_title.frame)) / 2 + CGRectGetHeight(_title.frame) / 2);
        [self.contentView addSubview:_title];
    }
    [self setNeedsDisplay];

}


- (void)drawRect:(CGRect)rect
{
    UIImage *upBg = [UIImage imageNamed:@"set_upbg.png"];
    UIImage *center = [UIImage imageNamed:@"set_center.png"];
    UIImage *downBg = [UIImage imageNamed:@"set_down.png"];
    UIImage *ground = [UIImage imageNamed:@"set_ground.png"];
    UIImage *oneUp = [UIImage imageNamed:@"set_1up.png"];
    UIImage *oneDown = [UIImage imageNamed:@"set_1down.png"];
    
    
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    
    if (_indexPath.section == 0)
    {
        if (_indexPath.row == 0) {
            oneUp = [oneUp resizableImageWithCapInsets:insets ];
            [oneUp drawInRect:rect];
        }
        else
        {
            oneDown = [oneDown resizableImageWithCapInsets:insets ];
            [oneDown drawInRect:rect];
         }
        
    }
    else if (_rowNum == 1) {
        ground = [ground resizableImageWithCapInsets:insets ];
        [ground drawInRect:rect];
    }
    else if (_indexPath.row == 0)
    {
        upBg = [upBg resizableImageWithCapInsets:insets ];
        [upBg drawInRect:rect];
    }
    else if (_indexPath.row == _rowNum - 1)
    {
        downBg = [downBg resizableImageWithCapInsets:insets ];
        [downBg drawInRect:rect];
    }
    else
    {
        center = [center resizableImageWithCapInsets:insets ];
        [center drawInRect:rect];
        
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
