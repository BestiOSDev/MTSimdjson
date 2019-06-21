//
//  MTJSONSerialization.m
//  MiaoTuProject
//
//  Created by dzb on 2019/6/21.
//  Copyright © 2019 大兵布莱恩特. All rights reserved.
//


#include "simdjson.h"
#include "jsonparser.h"
#import "MTJSONSerialization.h"
#import <CoreFoundation/CoreFoundation.h>

@interface MTJSONSerialization ()

@end

@implementation MTJSONSerialization

/// 接下JSON中的对象类型 类似NSDictionary
NSDictionary * parsedObject(ParsedJson::iterator &pjh) {
    
    NSMutableDictionary *_dictRef = [NSMutableDictionary dictionaryWithCapacity:10];
    if (pjh.down()) {
        NSString *hashKey = nil;
        do {
            if (pjh.is_string()) {
                hashKey = [NSString stringWithUTF8String:pjh.get_string()];
            } else {
                hashKey = @"";
            }
            pjh.next();
            if (pjh.is_array()) {
                NSArray *subArray = parsedArray(pjh);
                [_dictRef setObject:subArray forKey:hashKey];
            } else if (pjh.is_object()) {
                NSDictionary *subDict = parsedObject(pjh);
                [_dictRef setObject:subDict forKey:hashKey];
            } else {
                id object = parsedOtherData(pjh);
                [_dictRef setObject:object forKey:hashKey];
            }
        } while (pjh.next());
        
        pjh.up();
    }
    return _dictRef;
}

///解析JSON中的集合类型 类似NSArray
NSArray * parsedArray(ParsedJson::iterator &pjh) {
    NSMutableArray *_arrayRef = [NSMutableArray array];
    if (pjh.down()) {
        do {
            if (pjh.is_object()) {
                NSDictionary *dict = parsedObject(pjh);
                [_arrayRef addObject:dict];
            } else if (pjh.is_array()) {
                NSArray *subArray = parsedArray(pjh);
                [_arrayRef addObject:subArray];
            } else {
                id value = parsedOtherData(pjh);
                [_arrayRef addObject:value];
            }
        } while (pjh.next());
        pjh.up();
    }
    return _arrayRef;
}

/// 解析其他类型 如NSNumber NSString
id  parsedOtherData(ParsedJson::iterator &pjh) {
    id anyObject = nil;
    if (pjh.is_string()) {
        anyObject = [[NSString alloc] initWithUTF8String:pjh.get_string()];
    } else if (pjh.is_double()) {
        anyObject = @(pjh.get_double());
    } else if (pjh.is_integer()) {
        anyObject = @(pjh.get_integer());
    } else if (pjh.is_true()) {
        anyObject = @(YES);
    } else if (pjh.is_false()) {
        anyObject = @(NO);
    } else {
        anyObject = [NSNull null];
    }
    return anyObject;
}


id compute_dump(ParsedJson::iterator &pjh) {
    if (pjh.is_object()) {
        return parsedObject(pjh);
    } else  {
        return parsedArray(pjh);
    }
}

//解析网络请求返回JSON原始数据
+ (id) sd_JSONObjectWithData:(NSData *)data {
    
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    std::string mystring = jsonString.UTF8String;
    ParsedJson pj = ParsedJson();
    bool success = pj.allocateCapacity(mystring.size());
    const int res = json_parse(mystring, pj);
    if (res != 0 || !success) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        return object;
    } else {
        ParsedJson::iterator pjh(pj);
        if (!pjh.isOk()) {
            std::cerr << " Could not iterate parsed result. " << std::endl;
            return nil;
        } else {
            return compute_dump(pjh);
        }
    }
    
}

/// 从文件中解析JSON数据
+ (id) sd_JSONObjectWithContentsOfFile:(NSString *)path {
    const char * filename = path.UTF8String;
    padded_string p = get_corpus(filename);
    ParsedJson pj = build_parsed_json(p);
    if(!pj.isValid()) {
        std::cout << pj.getErrorMsg() << std::endl;
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            return object;
        } else {
            return nil;
        }
    } else {
        ParsedJson::iterator pjh(pj);
        if (!pjh.isOk()) {
            std::cerr << " Could not iterate parsed result. " << std::endl;
            return nil;
        } else {
            return compute_dump(pjh);
        }
    }

}


@end




