//
//  ReguserInputView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"
@interface ReguserInputView : UIView
{
    void(^_reguser)();
    void(^_sendMsg)();
}
@property (nonatomic, strong)BaseTextField *accountField;
@property (nonatomic, strong)BaseTextField *codeField;
@property (nonatomic, strong)BaseTextField *pwdField;
@property (nonatomic, strong)BaseTextField *rePwdField;
- (id)initWithReguser:(void(^)())reguser sendMsg:(void(^)())sendMsg;
- (void)stopRunTimer;

@end
