//
//  MTJSONSerialization.h
//  MiaoTuProject
//
//  Created by dzb on 2019/6/21.
//  Copyright © 2019 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTJSONSerialization : NSObject

//解析网络请求返回JSON原始数据
+ (id) sd_JSONObjectWithData:(NSData *)data;
/// 从文件中解析JSON数据
+ (id) sd_JSONObjectWithContentsOfFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
