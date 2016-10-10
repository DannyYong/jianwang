//
//  RequestAPI.h
//  Request
//
//  Created by ZIYAO YANG on 24/11/2015.
//  Copyright © 2015 Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppAPIClient.h"

@interface RequestAPI : NSObject

+ (void)getURL:(NSString *)request withParameters:(NSDictionary *)parameter success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)postURL:(NSString *)request withParameters:(NSDictionary *)parameter success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
