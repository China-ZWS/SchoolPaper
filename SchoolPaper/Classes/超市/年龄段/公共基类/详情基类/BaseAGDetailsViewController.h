//
//  BaseAGDetailsViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "SideSegmentController.h"
#import "StarRateView.h"

@interface BaseAGDetailsViewController : SideSegmentController
{
    NSDictionary *_datas;
    UIImageView *_headerImageView;
    UILabel *_useCount;
    UILabel *_status;
    UILabel *_source;
    
    UILabel *_catalogue;
    UILabel *_author;
    UILabel *_wordCount;
    StarRateView *_rate;
    
}
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *useCount;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *source; //来源

@property (nonatomic, strong) UILabel *catalogue;
@property (nonatomic, strong) UILabel *author;
@property (nonatomic, strong) UILabel *wordCount;
@property (nonatomic, strong) StarRateView *rate;

- (id)initWithViewControllers:(NSArray *)viewControllers datas:(NSDictionary *)datas;
- (void)lodingDatas:(NSDictionary *)datas;
@end
