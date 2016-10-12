//
//  Profile.h
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *idCard;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *favorite;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
