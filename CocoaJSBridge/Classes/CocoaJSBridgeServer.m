//
//  CocoaJSBridgeServer.m
//  CocoaJSBridge
//
//  Created by 廖亚雄 on 2019/5/15.
//

#import "CocoaJSBridgeServer.h"
#import "HTTPServer.h"
#import "JSBridgeConnection.h"
@interface CocoaJSBridgeServer ()

@property(nonatomic, strong) HTTPServer *httpServer;
@end

@implementation CocoaJSBridgeServer

- (instancetype)init {
    if (self == [super init]) {
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:6565];
        [_httpServer setConnectionClass:[JSBridgeConnection class]];
        NSError *error = nil;
        [_httpServer start:&error];
    }
    return self;
}

- (int) port {
    return [_httpServer listeningPort];
}

- (BOOL) isRunnig {
    return [_httpServer isRunning];
}


@end
