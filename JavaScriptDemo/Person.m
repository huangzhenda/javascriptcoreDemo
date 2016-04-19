//
//  Person.m
//  JavaScriptDemo
//
//  Created by hwangzhenda on 16/4/19.
//  Copyright © 2016年 hwangzhenda. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize sum = _sum;

- (NSString *)whatYouName {
    
    return @"my name is huangzhenda";
}

- (NSInteger)addA:(NSInteger)a b:(NSInteger)b {

    self.sum += a + b;
    return a + b;
}

- (NSInteger)add:(NSInteger)a b:(NSInteger)b {
    
    self.sum += a + b;
    return a + b;
}

@end
