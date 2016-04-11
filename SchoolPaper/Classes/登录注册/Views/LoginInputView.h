//
//  LoginInputView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"
@interface LoginInputView : UIView
{
    void(^_login)();
}
@property (nonatomic, strong)BaseTextField *accountField;
@property (nonatomic, strong)BaseTextField *pwdField;


- (id)initWithlogin:(void(^)())login;
@end
