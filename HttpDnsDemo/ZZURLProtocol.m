//
//  ZZURLProtocol.m
//  HttpDnsDemo
//
//  Created by isee15 on 2016/12/7.
//  Copyright © 2016年 isee15. All rights reserved.
//

#import "ZZURLProtocol.h"

@implementation ZZURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"request: %@", request);
    return NO;
}
@end
