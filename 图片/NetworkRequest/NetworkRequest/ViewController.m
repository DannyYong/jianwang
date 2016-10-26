//
//  ViewController.m
//  NetworkRequest
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString * userPhone;
    NSString * password;
    NSString * nickName;
}


@property (weak, nonatomic) IBOutlet UITextField *textField;//输入验证码

- (IBAction)getCodeAction:(UIButton *)sender forEvent:(UIEvent *)event;//获取验证码

- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event;//注册


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    userPhone = @"";
    
    password = @"";
    
    nickName = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCodeAction:(UIButton *)sender forEvent:(UIEvent *)event
{
    //接口路径
    NSString * request = @"/register/verificationCode";
    
    //接口入参
    NSDictionary * parameters = @{ @"userTel" : userPhone, @"type" : @1 };
    
    //执行get请求
    [RequestAPI getURL:request withParameters:parameters success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error.description);
        
    }];
}

- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event
{
    
}

@end
