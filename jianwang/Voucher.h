//
//  Voucher.h
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Voucher : NSObject

@property (strong, nonatomic) NSString *voucherId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *orginPrice;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *soldNo;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *rule;
@property (strong, nonatomic) NSString *promot;
@property (strong, nonatomic) NSString *avaiTime;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *clubName;
@property (strong, nonatomic) NSString *clubAddr;
@property (strong, nonatomic) NSArray *clubPhones;
@property (strong, nonatomic) NSArray *features;

- (id)initWithDictionary:(NSDictionary *)dic;
- (id)initWithDetailDictionary:(NSDictionary *)dic;

@end
