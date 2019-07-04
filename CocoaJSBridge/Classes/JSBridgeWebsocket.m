//
//  JSBridgeWebsocket.m
//  PerfectJSBridge
//
//  Created by 廖亚雄 on 2019/4/4.
//  Copyright © 2019 廖亚雄. All rights reserved.
//

#import "JSBridgeWebsocket.h"
#import "HTTPLogging.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN | HTTP_LOG_FLAG_TRACE;

@implementation JSBridgeWebsocket

//- (void) senddata {
//    [self sendMessage:@"string"];
//    [self sendMessage:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[@"1",@2,@3] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
//    [self sendMessage:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"1":@"sada",@"2":@3} options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
//    [self send:@{@"action":@"test",@"service":@"service",@"data":@{@"1":@"sada",@"2":@3,}} responseCallback:nil handlerName:@"send"];
//}
//- (void)didOpen
//{
//    HTTPLogTrace();
//
//    [super didOpen];
//
////    [self sendMessage:@"Welcome to my WebSocket"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(senddata) name:@"senddata" object:nil];
////    _uniqueId = 0;
////    [self registerHandler:@"send" handler:^(id data, JSBridgeWebsocketCallback callback) {
////        if ([data[@"action"] isEqualToString:@"test"]) {
////            callback(@{@"1":@"sada",@"2":@3,@"action":@"test"});
////        }
////    }];
//
//}
//
//- (void)didReceiveMessage:(NSString *)msg
//{
//    HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
//
////    [self sendMessage:[NSString stringWithFormat:@"%@", [NSDate date]]];
//
////    [self flushMessageQueue:msg];
//}
//
//- (void)didClose
//{
//    HTTPLogTrace();
//
//    [super didClose];
//}




@end
