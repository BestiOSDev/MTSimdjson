基于 simdjson接下json数据 [simdjson](https://github.com/lemire/simdjson)
看了戴铭老师的iOS开发高手课程后 [26 | 如何提高 JSON 解析的性能？](https://time.geekbang.org/column/article/93819) 对simdjson很感兴趣 于是就自己尝试把simdjson代码变成成静态库 ,对比下系统的NSJSONSerialization 分析其性能 

```
- (void)viewDidLoad {
[super viewDidLoad];


dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{

///超大json数据
[self testWithSDJSONFileName:@"citm_catalog"];
[self testNSJSONFileName:@"citm_catalog"];

[self testWithSDJSONFileName:@"package-lock"];
[self testNSJSONFileName:@"package-lock"];

[self testWithSDJSONFileName:@"package"];
[self testNSJSONFileName:@"package"];

//twitterescaped
[self testWithSDJSONFileName:@"twitter"];
[self testNSJSONFileName:@"twitter"];

[self testWithSDJSONFileName:@"random"];
[self testNSJSONFileName:@"random"];

[self testWithSDJSONFileName:@"mesh.pretty"];
[self testNSJSONFileName:@"mesh.pretty"];

//small data

//twitter_timeline
[self testWithSDJSONFileName:@"twitter_timeline"];
[self testNSJSONFileName:@"twitter_timeline"];

[self testWithSDJSONFileName:@"repeat"];
[self testNSJSONFileName:@"repeat"];

[self testWithSDJSONFileName:@"truenull"];
[self testNSJSONFileName:@"truenull"];

[self testWithSDJSONFileName:@"flatadversarial"];
[self testNSJSONFileName:@"flatadversarial"];

[self testWithSDJSONFileName:@"demo"];
[self testNSJSONFileName:@"demo"];
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

```
####测试结果

2019-06-21 21:01:42.320578+0800 MTSimdjson[5427:64308] citm_catalog simdjson Linked in 32.685995 ms
2019-06-21 21:01:42.331235+0800 MTSimdjson[5427:64308] citm_catalog system Linked in 9.927034 ms

2019-06-21 21:01:42.332638+0800 MTSimdjson[5427:64308] package-lock simdjson Linked in 0.445008 ms
2019-06-21 21:01:42.333043+0800 MTSimdjson[5427:64308] package-lock system Linked in 0.244975 ms

2019-06-21 21:01:42.334273+0800 MTSimdjson[5427:64308] package simdjson Linked in 0.033975 ms
2019-06-21 21:01:42.334433+0800 MTSimdjson[5427:64308] package system Linked in 0.016928 ms

2019-06-21 21:01:42.349764+0800 MTSimdjson[5427:64308] twitter simdjson Linked in 12.775898 ms
2019-06-21 21:01:42.355304+0800 MTSimdjson[5427:64308] twitter system Linked in 5.193949 ms

2019-06-21 21:01:42.372887+0800 MTSimdjson[5427:64308] random simdjson Linked in 14.144063 ms
2019-06-21 21:01:42.379515+0800 MTSimdjson[5427:64308] random system Linked in 6.255984 ms

2019-06-21 21:01:42.400383+0800 MTSimdjson[5427:64308] mesh.pretty simdjson Linked in 15.720010 ms
2019-06-21 21:01:42.423751+0800 MTSimdjson[5427:64308] mesh.pretty system Linked in 22.629023 ms

2019-06-21 21:01:42.425485+0800 MTSimdjson[5427:64308] twitter_timeline simdjson Linked in 0.821948 ms
2019-06-21 21:01:42.426221+0800 MTSimdjson[5427:64308] twitter_timeline system Linked in 0.571012 ms

2019-06-21 21:01:42.427058+0800 MTSimdjson[5427:64308] repeat simdjson Linked in 0.325918 ms
2019-06-21 21:01:42.427323+0800 MTSimdjson[5427:64308] repeat system Linked in 0.105023 ms

2019-06-21 21:01:42.428360+0800 MTSimdjson[5427:64308] truenull simdjson Linked in 0.326991 ms
2019-06-21 21:01:42.428588+0800 MTSimdjson[5427:64308] truenull system Linked in 0.064015 ms

2019-06-21 21:01:42.429058+0800 MTSimdjson[5427:64308] flatadversarial simdjson Linked in 0.024080 ms
2019-06-21 21:01:42.429219+0800 MTSimdjson[5427:64308] flatadversarial system Linked in 0.014901 ms

2019-06-21 21:01:42.429624+0800 MTSimdjson[5427:64308] demo simdjson Linked in 0.027061 ms
2019-06-21 21:01:42.429761+0800 MTSimdjson[5427:64308] demo system Linked in 0.012040 ms


通过实验发现 simdjson 纯解析json数据 要比 NSJSONSerialization 快些 但是要将解析出来的json数据 转成OC NSDictionary 或者 NSArray 效率比 NSJSONSerialization 低些 ,可能是我在转换时候代码效率比较低 希望大家有更好的方式可以提供下宝贵意见
