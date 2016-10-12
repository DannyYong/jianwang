//
//  singInViewController.m
//  jianwang
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 cj. All rights reserved.
//

#import "singInViewController.h"
#import "Profile.h"
@interface singInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameCM;
@property (weak, nonatomic) IBOutlet UITextField *passWordCM;
- (IBAction)singInCM:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation singInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self. navigationItem.title = @"登录";
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)singInCM:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_userNameCM.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PhoneEmpity", nil) andTitle:nil onView:self];
        return;
    }
    NSCharacterSet *notDicits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if (_userNameCM.text.length != 11 || [_userNameCM.text rangeOfCharacterFromSet:notDicits].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PhoneError", nil) andTitle:nil onView:self];
        return;
    }
    if (_passWordCM.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"PasswordEmpity",nil) andTitle:nil onView:self];
        return;
    }
    [self readyForing];
}
- (void) readyForing{
    NSString *request =@"/login/getKey";
    NSDictionary *parments = @{
                               @"deviceId":[Utilities uniqueVendor],  @"deviceType" : @7001
                               };
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [RequestAPI getURL:request withParameters:parments success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"get responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            //单例化
            NSDictionary *dic =[responseObject objectForKey:@"result"];
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"Modulus"];
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"Exponent"];
            [[StorageMgr singletonStorageMgr]addKey:@"Modulus" andValue:[dic objectForKey: @"modulus"] ];
            [[StorageMgr singletonStorageMgr]addKey:@"Exponent" andValue:[dic objectForKey: @"exponent"]];
            [self singIn];
        }else{
            NSString *errorDesc = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorDesc andTitle:nil onView:self];
        }
    } failure:^(NSError *error) {
        [aiv stopAnimating];
        NSLog(@"get error = %@",error.description);
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
    }];
}
- (void)singIn{
    NSString *request = @"/login";
    //使用单例化保护密码
    NSString *encodedPwd = [NSString encryptWithPublicKeyFromModulusAndExponent:[_passWordCM.text getMD5_32BitString].UTF8String modulus:[[StorageMgr singletonStorageMgr]objectForKey:@"Modulus"]  exponent:[[StorageMgr singletonStorageMgr]objectForKey:@"Exponent" ]];
    
    NSDictionary *parments =@{
                              @"userName":_userNameCM, @"password" :encodedPwd, @"deviceType": @7001,  @"deviceId" : [Utilities uniqueVendor]
                              };
    //菊花膜
    UIActivityIndicatorView *avi =[Utilities getCoverOnView:self.view];
    
    //post类型
    [RequestAPI postURL:request withParameters:parments success:^(id responseObject) {
        [avi stopAnimating];
        NSLog(@"post responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *proFileInfo = responseObject[@"result"];
            [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:proFileInfo[@"memberId"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
@end
