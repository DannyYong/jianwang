//
//  Profile.m
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (id)initWithDictionary:(NSDictionary *)dic {
    
    _memberId = [dic[@"memberId"] isKindOfClass:[NSNull class]] ? @"" : dic[@"memberId"];
    _phone = [dic[@"contactTel"] isKindOfClass:[NSNull class]] ? @"" : dic[@"contactTel"];
    _nickName = [dic[@"memberName"] isKindOfClass:[NSNull class]] ? @"" : dic[@"memberName"];
    _age = [dic[@"age"] isKindOfClass:[NSNull class]] ? @"" : dic[@"age"];
    _birthday = [dic[@"birthday"] isKindOfClass:[NSNull class]] ? @"" : dic[@"birthday"];
    _idCard = [dic[@"identificationcard"] isKindOfClass:[NSNull class]] ? @"" : dic[@"identificationcard"];
    _avatarUrl = [dic[@"memberUrl"] isKindOfClass:[NSNull class]] ? @"" : dic[@"memberUrl"];
     _memberpoint = [dic[@"memberPoint"] isKindOfClass:[NSNull class]]? @"": dic[@"memberPoint"];
    _collection = [dic[@"collection"] isKindOfClass:[NSNull class] ] ? @"":dic[@"collection"];
    if ([dic[@"memberSex"] isKindOfClass:[NSNull class]]) {
        _gender = @"";
    } else {
        switch ([dic[@"memberSex"] integerValue]) {
            case 1:
                _gender = @"男";
                break;
            case 2:
                _gender = @"女";
                break;
            default:
                _gender = @"";
                break;
        }
    }
   
    return self;
}

@end
