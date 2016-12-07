//
//  ZZSecurityPolicy.h
//  HttpDnsDemo
//
//  Created by isee15 on 2016/12/7.
//  Copyright © 2016年 isee15. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface ZZSecurityPolicy : AFSecurityPolicy

@property(nonatomic, copy) NSString *host;
@end
