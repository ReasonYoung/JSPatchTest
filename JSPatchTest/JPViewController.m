//
//  ViewController.m
//  JSPatchTest
//
//  Created by RWY on 16/8/18.
//  Copyright © 2016年 rwy. All rights reserved.
//

#import "JPViewController.h"
#import "InputTextView.h"
#import <IQKeyboardManager.h>
#import "AutoViewController.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define TopViewHeight 64.0

@interface JPViewController ()

@property (weak, nonatomic) IBOutlet InputTextView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHCons;

@end

@implementation JPViewController

#pragma mark - 导入IQKeyboardManager后，默认所有的页面都有了解决键盘弹起遮挡UITextField/UITextView的这个功能，如果你在哪一个界面不想有这个效果可以在当前界面控制器的生命周期方法中进行设置：
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Push JPTableViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    
    [self loadButton];
    [self loadButton2];
    
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

- (void)loadButton {
    UIButton *tipBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 180, 200, 30)];
    [tipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [tipBtn setTitle:@"hello_jspatch" forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tipBtn];
}

- (void)loadButton2 {
    UIButton *tipBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 230, 200, 30)];
    [tipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [tipBtn setTitle:@"NextVC" forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(handleBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tipBtn];
}

- (void)handleBtn:(UIButton *)sender
{
    AutoViewController *autoViewController = [[AutoViewController alloc] init];
    [self.navigationController pushViewController:autoViewController animated:YES];
}

- (void)handleBtn2:(UIButton *)sender
{
    AutoViewController *autoViewController = [[AutoViewController alloc] init];
    [self.navigationController pushViewController:autoViewController animated:YES];
}

- (void)clickedBtn:(UIButton *)sender
{
    NSLog(@"点击了btn按钮");
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

@end
