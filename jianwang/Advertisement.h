//
//  Advertisement.h
//  jianshenhui
//
//  Created by ZIYAO YANG on 19/07/2016.
//  Copyright © 2016 com.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advertisement : NSObject

@property (strong, nonatomic) NSString *adId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *linkUrl;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
