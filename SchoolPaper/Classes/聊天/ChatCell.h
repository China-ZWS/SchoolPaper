//
//  ChatCell.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-3.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJCell.h"

@protocol ChatCellDelegate <NSObject>

- (void)playSound:(NSString *)sound;
- (void)reSend:(id)datas;
@end
@interface ChatCell : PJCell
@property (nonatomic, assign) id<ChatCellDelegate>delegate;
@property (nonatomic, strong) UIButton *backImgView;
@property (nonatomic, strong) UILabel *soundTime;
@property (nonatomic, strong) UIImageView *contentImg;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIImageView *send_status;
@end
