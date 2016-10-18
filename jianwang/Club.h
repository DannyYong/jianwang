//
//  Club.h
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Club : NSObject

@property (strong, nonatomic) NSString *clubId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSMutableArray *vouchers;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
