//
//  CirclePostedViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-30.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "CirclePostedViewController.h"
#import "BaseTextView.h"
#import "BaseTextField.h"

@interface ImageCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (void)setDatas:(NSArray *)datas index:(NSInteger)index
{
    UIImage *image = nil;
    if ([datas count] == index)
    {
        image = [UIImage imageNamed:@"add_icon.png"];
    }
    else
    {
        image = datas[index];
    }
    _imageView.image = image;

}

@end


@interface CirclePostedViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, BaseTextFieldDelegate,BaseTextViewDelegate>
{
    UITextView *_textView;
    BaseTextField *_fieldView;
    UICollectionView *_collection;
    UIButton *_finishBtn;
    NSMutableArray *_picDatas;
    NSInteger _deleteIndex;
    NSDictionary *_dic;
    
    PostedType _postedType;
}
@end

@implementation CirclePostedViewController

- (id)initWithDatas:(id)datas postedType:(PostedType)postedType;
{
    if ((self = [super init])) {
        _dic = datas;
        _postedType = postedType;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        [self.navigationItem setNewTitle:[Base64 textFromBase64String:datas[@"circleName"]]];
        _picDatas = [NSMutableArray array];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_postedType == kSchoolAndClass)
    {
        _textView = [[BaseTextView alloc] initWithFrame:CGRectMake(ScaleX(20), ScaleY(15), DeviceW - ScaleX(20) * 2, ScaleH(220))];
        _textView.font = Font(17);
        _textView.delegate = self;
        [self.view addSubview:_textView];
    }
    else if (_postedType == kTopic)
    {
        _fieldView = [[BaseTextField alloc] initWithFrame:CGRectMake(ScaleX(20), ScaleY(15), DeviceW - ScaleX(20) * 2, ScaleH(50))];
        _fieldView.font = Font(20);
        _fieldView.delegate = self;
        _fieldView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"话题标题" attributes:@{NSForegroundColorAttributeName: CustomGray}];

        [_fieldView getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1 masksToBounds:YES];
        [self.view addSubview:_fieldView];
        
        _textView = [[BaseTextView alloc] initWithFrame:CGRectMake(ScaleX(20), CGRectGetMaxY(_fieldView.frame) + ScaleH(15), DeviceW - ScaleX(20) * 2, ScaleH(220))];
        _textView.font = Font(17);
        _textView.delegate = self;
        [self.view addSubview:_textView];
    }
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), DeviceW, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_textView.frame)) collectionViewLayout:flowLayout];
    _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collection registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    _collection.delegate=self;
    _collection.dataSource=self;
    _collection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _picDatas.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, ScaleH(100));
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    footerView.backgroundColor = [UIColor clearColor];
    
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame = CGRectMake(ScaleW(20), (ScaleH(60) - ScaleH(50)) / 2, CGRectGetWidth(footerView.frame) - ScaleW(20) * 2, ScaleH(50));
    [_finishBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [_finishBtn setTitle:@"发 帖" forState:UIControlStateNormal];
    _finishBtn.titleLabel.font = Font(20);
    [_finishBtn addTarget:self action:@selector(eventWithFinish) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_finishBtn];
    if (_textView.text.length)
    {
        _finishBtn.backgroundColor = RGBA(23, 103, 223, 1);
        _finishBtn.userInteractionEnabled = YES;
    }
    else
    {
        _finishBtn.userInteractionEnabled = NO;
        _finishBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    return footerView;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inset = ScaleW(80);
    return CGSizeMake(inset, inset);
}
////定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(ScaleH(15), ScaleW(20), ScaleH(15), ScaleW(20) );//分别为上、左、下、右
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return ScaleW(5);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return ScaleH(5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_picDatas index:indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _picDatas.count)
    {
        if (_picDatas.count >= 9)
        {
            [self.view makeToast:@"最多上传9张"];
            return;
        }
        [self handlePanFrom];
    }
    else
    {
        _deleteIndex = indexPath.row;
        [self deletePanFrom];
    }
}

#pragma mark - 获取照片
- (void)handlePanFrom
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view.window];
}

- (void)deletePanFrom
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除已选图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.firstOtherButtonIndex == buttonIndex )
    {
        [_picDatas removeObjectAtIndex:_deleteIndex];
        [_collection reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.destructiveButtonIndex == buttonIndex)
    {
        [self getCamera];
    }
    else if (actionSheet.firstOtherButtonIndex == buttonIndex)
    {
        [self getPhotoLibrary];
    }
}


#pragma mark - 拍照
- (void)getCamera
{
    UIImagePickerController *pickerImage = [UIImagePickerController new];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    else
    {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage];
    
}

#pragma mark - 相册
- (void)getPhotoLibrary
{
    UIImagePickerController *pickerImage = [UIImagePickerController new];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage];
}


#pragma mark -UIImagePickerControllerDelegate,UINavigationControllerDelegate


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.view makeToast:@"取消成功"];
    [self dismissViewController];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewController];
    [_picDatas addObject:info[UIImagePickerControllerEditedImage]];
    
    [_collection reloadData];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    if (toBeString.length)
    {
        _finishBtn.backgroundColor = RGBA(23, 103, 223, 1);
        _finishBtn.userInteractionEnabled = YES;
    }
    else
    {
        _finishBtn.userInteractionEnabled = NO;
        _finishBtn.backgroundColor = [UIColor lightGrayColor];
    }
    return YES;
}

- (void)eventWithFinish
{
    [self.view endEditing:YES];
    
    [self dismissViewController];
    [MBProgressHUD showMessag:@"问题提交中..." toView:self.view];
    NSString *account = [Infomation readInfo][@"id"];
    NSString *secret_key = [Infomation readInfo][@"secret_key"];
    NSString *code = @"1";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code"] = code;
    params[@"secret_key"] = secret_key;
    params[@"account"] = account;
  
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *servlet = nil;
    if (_postedType == kSchoolAndClass)
    {
        param[@"circleId"] = _dic[@"circleId"];
        param[@"circletype"] = _dic[@"circleType"];
        param[@"postContent"] = [Base64 base64StringFromText:_textView.text];
        servlet = submitTieServlet;
    }
    else if (_postedType == kTopic)
    {
        param[@"boardId"] = _dic[@"circleId"];
        param[@"boardTitle"] = [Base64 base64StringFromText:_fieldView.text];
        param[@"boardContent"] = [Base64 base64StringFromText:_textView.text];
        servlet = submitBoardServlet;
    }
    param[@"userId"] = [Infomation readInfo][@"id"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"param"] = jsonString;
    
    [ZWSRequest postRequestWithURL:[serverUrl stringByAppendingString:servlet] postParems:params images:_picDatas  success:^(id datas)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
         NSNotificationPost(RefreshWithViews, nil, nil);
         
     }
                           failure:^(NSString *msg)
     {
         [self.view makeToast:msg];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];

    
    

    _connection = [BaseModel POST:schoolAndClassServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                   }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textView:(BaseTextView *)textView heightWithContent:(CGFloat)textHeigh
{
    
    if (textHeigh > 0) {
        CGRect rect = self.view.frame;
        rect.origin.y -= textHeigh;
        self.view.frame = rect;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
