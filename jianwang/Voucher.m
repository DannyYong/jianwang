//
//  Voucher.m
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import "Voucher.h"

@implementation Voucher

- (id)initWithDictionary:(NSDictionary *)dic {
    
    _voucherId = [dic[@"id"] isKindOfClass:[NSNull class]] ? @"" : dic[@"id"];
    _name = [dic[@"name"] isKindOfClass:[NSNull class]] ? @"" : dic[@"name"];
    _category = [dic[@"categoryName"] isKindOfClass:[NSNull class]] ? @"" : dic[@"categoryName"];
    _orginPrice = [dic[@"orginPrice"] isKindOfClass:[NSNull class]] ? @"" : [dic[@"orginPrice"] stringValue];
    _price = [dic[@"price"] isKindOfClass:[NSNull class]] ? @"" : [dic[@"price"] stringValue];
    _soldNo = [dic[@"sellNumber"] isKindOfClass:[NSNull class]] ? @"" : [dic[@"sellNumber"] stringValue];
    _imageUrl = [dic[@"logo"] isKindOfClass:[NSNull class]] ? @"" : dic[@"logo"];
    
    return self;
}

- (id)initWithDetailDictionary:(NSDictionary *)dic {
    
    _voucherId = [dic[@"eId"] isKindOfClass:[NSNull class]] ? @"" : dic[@"eId"];
    _name = [dic[@"eName"] isKindOfClass:[NSNull class]] ? @"" : dic[@"eName"];
    _orginPrice = [dic[@"orginPrice"] isKindOfClass:[NSNull class]] ? @"" : [dic[@"orginPrice"] stringValue];
    _price = [dic[@"currentPrice"] isKindOfClass:[NSNull class]] ? @"" : [dic[@"currentPrice"] stringValue];
    _soldNo = [dic[@"saleCount"] isKindOfClass:[NSNull class]] ? @"" : [dic[@"saleCount"] stringValue];
    _imageUrl = [dic[@"eLogo"] isKindOfClass:[NSNull class]] ? @"" : dic[@"eLogo"];
    _rule = [dic[@"rules"] isKindOfClass:[NSNull class]] ? @"" : dic[@"rules"];
    _promot = [dic[@"ePromot"] isKindOfClass:[NSNull class]] ? @"" : dic[@"ePromot"];
    _avaiTime = [dic[@"useDate"] isKindOfClass:[NSNull class]] ? @"" : dic[@"useDate"];
    _startDate = [dic[@"beginDate"] isKindOfClass:[NSNull class]] ? @"" : dic[@"beginDate"];
    _endDate = [dic[@"endDate"] isKindOfClass:[NSNull class]] ? @"" : dic[@"endDate"];
    _latitude = [dic[@"latitude"] isKindOfClass:[NSNull class]] ? @"" : dic[@"latitude"];
    _longitude = [dic[@"longitude"] isKindOfClass:[NSNull class]] ? @"" : dic[@"longitude"];
    _clubName = [dic[@"eClubName"] isKindOfClass:[NSNull class]] ? @"" : dic[@"eClubName"];
    _clubAddr = [dic[@"eAddress"] isKindOfClass:[NSNull class]] ? @"" : dic[@"eAddress"];
    if ([dic[@"clubTel"] isKindOfClass:[NSNull class]]) {
        _clubPhones = [NSArray new];
    } else {
        NSString *feaStr = dic[@"clubTel"];
        _clubPhones = [feaStr componentsSeparatedByString:@","];
    }
    if ([dic[@"eFeature"] isKindOfClass:[NSNull class]]) {
        _features = [NSArray arrayWithObjects:NSLocalizedString(@"NotAvailable", nil), nil];
    } else {
        NSString *feaStr = dic[@"eFeature"];
        _features = [feaStr componentsSeparatedByString:@","];
    }
    
    return self;
}

@end
