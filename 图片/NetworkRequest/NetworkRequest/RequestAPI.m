//
//  RequestAPI.m
//  Request
//
//  Created by ZIYAO YANG on 24/11/2015.
//  Copyright © 2015 Pro. All rights reserved.
//

#import "RequestAPI.h"

@implementation RequestAPI

+ (void)getURL:(NSString *)request withParameters:(NSDictionary *)parameter success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *server = @"http://beilywx.xicp.net:43986";
    NSString *url = [NSString stringWithFormat:@"%@%@", server, request];
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[AppAPIClient sharedClient] GET:decodedURL parameters:parameter progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        success(responseObject);
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)postURL:(NSString *)request withParameters:(NSDictionary *)parameter success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *server = @"http://beilywx.xicp.net:43986";
    NSString *url = [NSString stringWithFormat:@"%@%@", server, request];
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[AppAPIClient sharedJSONClient] POST:decodedURL parameters:parameter progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        success(responseObject);
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error);
    }];
}

@end
