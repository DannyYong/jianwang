//
//  singUpViewController.m
//  
//
//  Created by admin on 16/10/11.
//
//

#import "singUpViewController.h"

@interface singUpViewController (){
    NSInteger time;
}
@property (weak, nonatomic) IBOutlet UIButton *singUpOut;
@property (weak, nonatomic) IBOutlet UITextField *userNamePhoneNumeber;
@property (weak, nonatomic) IBOutlet UITextField *veriCode;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *possWord;
@property (weak, nonatomic) IBOutlet UITextField *nicKName;
- (IBAction)getCodeAction:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)singUpAction:(UIButton *)sender forEvent:(UIEvent *)event;


/** 定时器 */
@property(nonatomic ,strong)NSTimer *timer;
@end

@implementation singUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]) {
        [self releaseData];
    }
}
- (void)releaseData{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击View隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//- (BOOL)textFileShouldReturn:(UITextField *)textFileld{
//    [textFileld resignFirstResponder];
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/** 获取验证码 */
- (IBAction)getCodeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_userNamePhoneNumeber.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PhoneEmpty", nil) andTitle:nil onView:self];
        return;
    }
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    //验证输入的手机号是否正确
    if (_userNamePhoneNumeber.text.length !=11 || [_userNamePhoneNumeber.text rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PhoneError", nil) andTitle:nil onView:self];
        return;
    }
   
    
    //验证码接口对接
    NSString *request = @"/register/verificationCode";
    NSDictionary *parameters = @{
                                 @"userTel" : _userNamePhoneNumeber.text,@"type" : @1
                                 };
    [RequestAPI getURL:request withParameters:parameters success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] != 8001) {
            NSString *errorDesc = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorDesc andTitle:nil onView:self];
        }
    } failure:^(NSError *error) {
        NSLog(@"errpr = %@",error.description);
        [Utilities popUpAlertViewWithMsg: NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
        
    }];
    
    //定时器时间
    time = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [_timer fire];
    
}

- (IBAction)singUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //点击注册按钮各种情况判断
    if (_userNamePhoneNumeber.text.length == 0 || _nicKName.text.length == 0 || _veriCode.text.length == 0 || _possWord.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"您还未完成所有操作！" andTitle:nil onView:self];
        return;
    }
   
    if (_userNamePhoneNumeber.text.length == 0) {
        
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PhoneEmpity", nil) andTitle:nil onView:self];
        return;
    }
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if (_userNamePhoneNumeber.text.length != 11 || [_userNamePhoneNumeber.text rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PhoneError", nil) andTitle:nil onView:self];
        return;
    }
    if (_possWord.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PasswordEmpity", nil) andTitle:nil onView:self];
        return;
    }
    if (_veriCode.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"VeriCodeEmpity", nil) andTitle:nil onView:self];
        return;
    }
    if (_nicKName.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NickNameEmpity", nil) andTitle:nil onView:self];
        return;
    }
    
    [self readyForEncoding];
}

/** 注册与登录时，密码进行加RSA加密，公匙和密匙 */
- (void)readyForEncoding{
    
    NSString *requset = @"/login/getKey";
    NSDictionary *parameters = @{
                                 @"deviceType" : @7001,@"deviceId" : [Utilities uniqueVendor]
                                 };
    //创建菊花膜
    UIActivityIndicatorView *aiv =[Utilities getCoverOnView:self.view];
    [RequestAPI getURL:requset withParameters:parameters success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"get responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            //单例化
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"Modulus"];
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"Exponent"];
            [[StorageMgr singletonStorageMgr]addKey:@"Modulus" andValue:[dic objectForKey:@"Modulus"]];
            [[StorageMgr singletonStorageMgr]addKey:@"Exponent" andValue:[dic objectForKey:@"Exponent"]];
            [self singUp];
            
        }else{
            NSString *errorDesc = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorDesc andTitle:nil onView:self];
            
        }
        
    } failure:^(NSError *error) {
        [aiv stopAnimating];
        NSLog(@"get error = %@",error.description);
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
        
    }];
};
/** 注册接口对接 */
- (void)singUp{
    NSString *request = @"/register";
    NSString *encodedPwd = [NSString encryptWithPublicKeyFromModulusAndExponent:[_possWord.text getMD5_32BitString].UTF8String modulus:[[StorageMgr singletonStorageMgr] objectForKey:@"Modulus"]  exponent:[[StorageMgr singletonStorageMgr]objectForKey:@"Exponent"]];
    NSDictionary *parameters = @{
                                 @"userTel":_userNamePhoneNumeber.text, @"userPsw":encodedPwd, @"nickName":_nicKName.text, @"city":@"0510", @"nums":_veriCode.text, @"deviceId":[Utilities uniqueVendor]
                                 };
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [RequestAPI postURL:request withParameters:parameters success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"post responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            NSString *errorDesc = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorDesc andTitle:nil onView:self];
        }
    } failure:^(NSError *error) {
        [aiv stopAnimating];
        NSLog(@"post error = %@",error.description);
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
    }];
}
/** 给定时器按钮设置文本 */
- (void)timeAction{
    if (time >= 0) {
        _getCodeBtn.enabled = NO;
        _getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%ld%@",(long)time,NSLocalizedString(@"CanObtain", nil)];
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ld%@",(long)time,NSLocalizedString(@"CanObtain", nil)] forState:UIControlStateNormal];
        time --;
    }else {
        _getCodeBtn.enabled = YES;
        [_getCodeBtn setTitle:NSLocalizedString(@"GetCode", nil) forState:UIControlStateNormal];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }

}
@end
