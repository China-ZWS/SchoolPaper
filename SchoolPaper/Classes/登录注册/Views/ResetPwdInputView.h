//
//  ResetPwdInputView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"

@interface ResetPwdInputView : UIView
{
    void(^_success)();
}

- (id)initWithSuccess:(void(^)())success;
@property (nonatomic, strong)BaseTextField *pwdField;
@property (nonatomic, strong)BaseTextField *rePwdField;

@end
