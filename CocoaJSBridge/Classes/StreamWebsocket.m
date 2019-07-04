//
//  StreamWebsocket.m
//  PerfectJSBridge
//
//  Created by 廖亚雄 on 2019/4/4.
//  Copyright © 2019 廖亚雄. All rights reserved.
//

#import "StreamWebsocket.h"
#import "HTTPLogging.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;

@implementation StreamWebsocket
- (void)didOpen
{
    HTTPLogTrace();
    
    [super didOpen];
    
    [self sendMessage:@"Welcome to my WebSocket"];
}

- (void)didReceiveMessage:(NSString *)msg
{
    HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:msg.UTF8String length:msg.length] options:NSJSONReadingMutableLeaves error:&error];
    
}

- (void)didClose
{
    HTTPLogTrace();
    
    [super didClose];
}

@end
