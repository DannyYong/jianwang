//
//  Profile.h
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property (strong, nonatomic) NSString *memberId;//用户ID
@property (strong, nonatomic) NSString *phone;//
@property (strong, nonatomic) NSString *nickName;//昵称
@property (strong, nonatomic) NSString *age;//年龄
@property (strong, nonatomic) NSString *birthday;//生日
@property (strong, nonatomic) NSString *idCard;//身份证
@property (strong, nonatomic) NSString *gender;//性别
@property (strong, nonatomic) NSString *avatarUrl;//头像链接
@property (strong, nonatomic) NSString *memberpoint;//
@property (nonatomic ,strong) NSString *collection;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
