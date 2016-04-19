//
//  ViewController.m
//  JavaScriptDemo
//
//  Created by hwangzhenda on 16/4/18.
//  Copyright © 2016年 hwangzhenda. All rights reserved.
//

#import "ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self ocToJs];
    [self jsToOcBlock];
}

//OC 调用 JS
- (void)ocToJs {

    //1. JSContxt执行js代码
    JSContext *context = [[JSContext alloc] init];
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:js];
    
    //Context小标
    //获取num对象
    JSValue *num = context[@"num"];
    NSLog(@"num: %d", num.toInt32);
    
    //获取数组
    JSValue *names = context[@"names"];
    NSLog(@"names: %@", names.toArray);
    JSValue *firstName = names[0];
    NSLog(@"%@",firstName.toString);

    //调用方法
    JSValue *tripleNum = [context evaluateScript:[NSString stringWithFormat:@"triple(%d)", 10]];
    NSLog(@"tripled: %d", tripleNum.toInt32);
    JSValue *triple = context[@"triple"];
    tripleNum = [triple callWithArguments:@[@10]];
    NSLog(@"tripled2: %d", tripleNum.toInt32);
    tripleNum = [context[@"triple"] callWithArguments:@[@10]];
    NSLog(@"tripled3: %d", tripleNum.toInt32);

}

//JS调用OC (block)
- (void)jsToOcBlock {
    
    //1. JSContxt执行js代码
    JSContext *context = [[JSContext alloc] init];
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:js];
    
    //定义一个block ，然后保存到context里面，其实就是转成JS的founction.
    context[@"ocAddFuncation"] = ^NSInteger(NSInteger a, NSInteger b){
        
        NSLog(@"oc方法被调用");
        return a + b;
    };

    JSValue *jsFuncation = context[@"jsAddFunction"];
    NSLog(@"调用js方法");
    JSValue *value = [jsFuncation callWithArguments:@[@2, @3]];
    NSLog(@"计算结果： %zd", value.toInt32);
    
    
    //2.
    //注册一个objc方法给js调用
    context[@"log"] = ^(NSString *msg){
        NSLog(@"js:msg:%@",msg);
    };
    //另一种方式，利用currentArguments获取参数
    context[@"log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) { NSLog(@"%@",obj); }
    };
    
    //使用js调用objc
    [context evaluateScript:@"log('hello,i am js side')"];
    
}

//JS调用OC （JSExport）
- (void)jsToOcProtocol {

    JSContext *context = [[JSContext alloc] init];
    
    Person *person = [[Person alloc] init];
    context[@"person"] = person;
    
    JSValue *value = [context evaluateScript:@"person.whatYouName()"];
    NSLog(@"name = %@",value.toString);
    
    JSValue *addValue = [context evaluateScript:@"person.addAB(1,2)"];
    NSLog(@"addValue = %zd",addValue.toInt32);
    
    JSValue *sumValue = context[@"sum"];
    NSLog(@"sumValue = %zd",sumValue.toInt32);
    
}

//错误处理
- (void)exceptionHadle {
    
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@"JS Error: %@",exception);
    };
    
    [context evaluateScript:@"function multiply(value1, value2) { return value1 * value}"];
}

//内存问题
- (void)memoryTest {

    //1. 不要在block引用context
    JSContext *jsContext = [[JSContext alloc] init];
    jsContext[@"block"] = ^(){
    
        JSValue *value = [JSValue valueWithObject:@"aaa" inContext:jsContext];
        NSLog(@"%@",[value toObject]);
    };
    
    
    //2.block引用了外部的对象，也会出现内存泄露
    JSValue *value = [JSValue valueWithObject:@"ssss" inContext:jsContext];
    jsContext[@"log"] = ^(){
        NSLog(@"%@",value);
    };
    //正确的做法，str对象是JS那边传递过来。
    jsContext[@"log"] = ^(NSString *str){
        NSLog(@"%@",str);
    };
    
    //3、OC对象不要用属性直接保存JSValue对象，因为这样太容易循环引用了。
}

- (void)otherTest {

//    第一行闭包， 第二行匿名函数
//    (function() { return 'hello objc' })
//    function() { return 'hello objc' }

    JSContext *context = [[JSContext alloc] init];
    //注册一个闭包
    JSValue *jsFunction = [context evaluateScript:@" (function() { return 'hello objc' })"];
    //调用
    JSValue *value = [jsFunction callWithArguments:nil];
    NSLog(@"%@",value.toString);
    
    //注册一个匿名函数
    [context evaluateScript:@"var hello = function() { return 'hello objc' }"];
    //调用
    JSValue *value2 = [context evaluateScript:@"hello()"];
    NSLog(@"%@",value2.toString);
    
}

@end
