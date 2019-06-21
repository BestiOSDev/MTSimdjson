//
//  ViewController.m
//  MTSimdjson
//
//  Created by dzb on 2019/6/21.
//  Copyright © 2019 大兵布莱恩特. All rights reserved.
//

#import "ViewController.h"
#import "MTJSONSerialization.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
//            ///超大json数据
//            [self testWithSDJSONFileName:@"citm_catalog"];
//            [self testNSJSONFileName:@"citm_catalog"];
//
//            [self testWithSDJSONFileName:@"package-lock"];
//            [self testNSJSONFileName:@"package-lock"];
//
//            [self testWithSDJSONFileName:@"package"];
//            [self testNSJSONFileName:@"package"];
//
//            //twitterescaped
//            [self testWithSDJSONFileName:@"twitter"];
//            [self testNSJSONFileName:@"twitter"];
//
//            [self testWithSDJSONFileName:@"random"];
//            [self testNSJSONFileName:@"random"];
//
//            [self testWithSDJSONFileName:@"mesh.pretty"];
//            [self testNSJSONFileName:@"mesh.pretty"];
//
//            //small data
            
            //twitter_timeline
            [self testWithSDJSONFileName:@"gsoc-2018"];
            [self testNSJSONFileName:@"gsoc-2018"];
//            
//            [self testWithSDJSONFileName:@"repeat"];
//            [self testNSJSONFileName:@"repeat"];
//            
//            [self testWithSDJSONFileName:@"truenull"];
//            [self testNSJSONFileName:@"truenull"];
//            
//            [self testWithSDJSONFileName:@"flatadversarial"];
//            [self testNSJSONFileName:@"flatadversarial"];
//            
//            [self testWithSDJSONFileName:@"demo"];
//            [self testNSJSONFileName:@"demo"];
        }];
        [op start];
    });
    
    
}

//simdjson JSON解析
- (void) testWithSDJSONFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    id object = [MTJSONSerialization sd_JSONObjectWithData:data];
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"%@ simdjson Linked in %f ms", fileName ,linkTime *1000.0);
}

///系统JSON解析
- (void) testNSJSONFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"%@ system Linked in %f ms", fileName ,linkTime *1000.0);
}



@end


