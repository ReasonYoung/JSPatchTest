//
//  AutoViewController.m
//  JSPatchTest
//
//  Created by RWY on 16/8/22.
//  Copyright © 2016年 rwy. All rights reserved.
//

#import "AutoViewController.h"
#import "InputTextView.h"
#import <IQKeyboardManager.h>
@interface AutoViewController ()

@property (weak, nonatomic) IBOutlet InputTextView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;

@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 设置文本框占位文字
    _inputView.placeholder = @"请输入内容";
    _inputView.placeholderColor = [UIColor redColor];
    
    // 监听文本框文字高度改变
    _inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
        // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
        // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
        _bottomHCons.constant = textHeight + 10;
    };
    
    // 设置文本框最大行数
    _inputView.maxNumberOfLines = 4;
}

// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 修改底部视图距离底部的间距
    _bottomCons.constant = endFrame.origin.y != screenH?endFrame.size.height:0;
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
