//
//  ForgotPwdInputView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"
@interface ForgotPwdInputView : UIView
{
    void(^_next)();
    void(^_sendMsg)();
}

@property (nonatomic, strong)BaseTextField *accountField;
@property (nonatomic, strong)BaseTextField *code;

- (id)initWithNext:(void(^)())next sendMsg:(void(^)())sendMsg;
- (void)stopRunTimer;

@end
