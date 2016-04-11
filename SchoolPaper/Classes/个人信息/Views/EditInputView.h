//
//  EditInputView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"
#import <MapKit/MapKit.h>

@interface EditInputView : UIView
{
    void(^_finish)();
}
@property (nonatomic, strong) BaseTextField *nameField;
@property (nonatomic, strong) BaseTextField *sexField;
@property (nonatomic, strong) BaseTextField *areaField;
@property (nonatomic, strong) BaseTextField *schoolField;
@property (nonatomic, strong) BaseTextField *gradeField;
@property (nonatomic, strong) BaseTextField *classField;

- (id)initWithFinish:(void(^)())finish;

@end
