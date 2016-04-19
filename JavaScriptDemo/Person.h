//
//  Person.h
//  JavaScriptDemo
//
//  Created by hwangzhenda on 16/4/19.
//  Copyright © 2016年 hwangzhenda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol PersonProtocol <JSExport>

@property (nonatomic, assign) NSInteger sum;

- (NSString *)whatYouName;

//用宏转换下，将JS函数名字指定为add；
JSExportAs(add, - (NSInteger)add:(NSInteger)a b:(NSInteger)b);

- (NSInteger)addA:(NSInteger)a b:(NSInteger)b;

@end


@interface Person : NSObject <PersonProtocol>

@end
