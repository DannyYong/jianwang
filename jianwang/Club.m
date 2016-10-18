//
//  Club.m
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import "Club.h"
#import "Voucher.h"

@implementation Club

- (id)initWithDictionary:(NSDictionary *)dic {
    
    _clubId = [dic[@"id"] isKindOfClass:[NSNull class]] ? @"" : dic[@"id"];
    _name = [dic[@"name"] isKindOfClass:[NSNull class]] ? @"" : dic[@"name"];
    _address = [dic[@"address"] isKindOfClass:[NSNull class]] ? @"" : dic[@"address"];
    _distance = [dic[@"distance"] isKindOfClass:[NSNull class]] ? @"" : [dic[@"distance"] stringValue];
    _imageUrl = [dic[@"image"] isKindOfClass:[NSNull class]] ? @"" : dic[@"image"];
    _vouchers = [NSMutableArray new];
    if (![dic[@"experience"] isKindOfClass:[NSNull class]]) {
        NSArray *voucherArr = dic[@"experience"];
        for (NSDictionary *voucherInfo in voucherArr) {
            Voucher *voucher = [[Voucher alloc] initWithDictionary:voucherInfo];
            [_vouchers addObject:voucher];
        }
    }
    
    return self;
}

@end
