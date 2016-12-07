//
//  main.m
//  HttpDnsDemo
//
//  Created by isee15 on 2016/12/7.
//  Copyright © 2016年 isee15. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ZZSecurityPolicy.h"
#import <HTTPDNS/HTTPDNS.h>
#import "ZZURLProtocol.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");

        [NSURLProtocol registerClass:[ZZURLProtocol class]];

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;

        ZZSecurityPolicy *policy = [ZZSecurityPolicy new];
        manager.securityPolicy = policy;

        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
        manager.responseSerializer = responseSerializer;

        NSString *originalUrl = @"https://baidu.com";
        NSURL *url = [NSURL URLWithString:originalUrl];

        policy.host = url.host;
        // 初始化客户端
        HTTPDNSClient *dns = [[HTTPDNSClient alloc] init];

        // 解析记录
        [dns getRecord:url.host callback:^(HTTPDNSRecord *record) {
            NSLog(@"IP : %@", record.ip);
            NSLog(@"description : %@", record.description);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            if (record.ip) {
                // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
                NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", record.ip, url.host);
                NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
                if (NSNotFound != hostFirstRange.location) {
                    NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:record.ip];
                    NSLog(@"New URL: %@", newUrl);
                    request.URL = [NSURL URLWithString:newUrl];
                    [request setValue:url.host forHTTPHeaderField:@"host"];
                }
            }

            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", response, responseObject);
                }
            }];
            [dataTask resume];

        }];

        // 清除缓存
        //[dns cleanAllCache];

        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
