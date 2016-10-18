//
//  Advertisement.m
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import "Advertisement.h"

@implementation Advertisement

- (id)initWithDictionary:(NSDictionary *)dic {
    
    _adId = [dic[@"id"] isKindOfClass:[NSNull class]] ? @"" : dic[@"id"];
    _title = [dic[@"title"] isKindOfClass:[NSNull class]] ? @"" : dic[@"title"];
    _comment = [dic[@"comment"] isKindOfClass:[NSNull class]] ? @"" : dic[@"comment"];
    _imgUrl = [dic[@"imgurl"] isKindOfClass:[NSNull class]] ? @"" : dic[@"imgurl"];
    _linkUrl = [dic[@"linkUrl"] isKindOfClass:[NSNull class]] ? @"" : dic[@"linkUrl"];
    
    return self;
}

@end
