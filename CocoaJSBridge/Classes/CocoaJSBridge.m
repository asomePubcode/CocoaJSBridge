//
//  CocoaJSBridge.m
//  CocoaJSBridge
//
//  Created by 廖亚雄 on 2019/7/3.
//

#import "CocoaJSBridge.h"
#import "CocoaJSBridgeServer.h"
#import "JSBridgeWebsocket.h"

NSString *const kBridgeLoad = @"https://__bridge_loaded__/";
NSString *const kBridgeInit = @"https://__bridge_init__/";
@interface CocoaJSBridge ()<WebSocketDelegate>
{
    long _uniqueId;
}

@property(nonatomic, strong) NSMutableDictionary *callbacksQueue;
@property(nonatomic, strong) NSMutableDictionary *handlersQueue;
@property(nonatomic, strong) JSBridgeWebsocket *ws;

@property(nonatomic, copy) NSString *identify;
@property(nonatomic, assign) int port;
@end

@implementation CocoaJSBridge

- (instancetype)initWithIdentify:(NSString *)identify {
    if (self == [super init]) {
        [CocoaJSBridge singleHTTPServer];
        self.port = [[CocoaJSBridge singleHTTPServer] port];
        self.identify = identify;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(websocketConnect:) name:@"" object:nil];
    }
    return self;
}

- (void)websocketConnect:(NSNotification *)noti {
    JSBridgeWebsocket *ws = noti.object;
    if ([[noti.userInfo allValues] containsObject:self.identify]) {
        self.ws = ws;
        self.ws.delegate = self;
    }
}

+ (CocoaJSBridgeServer*)singleHTTPServer {
    static dispatch_once_t onceToken;
    static CocoaJSBridgeServer *jsBridgeServer;
    dispatch_once(&onceToken, ^{
        jsBridgeServer = [CocoaJSBridgeServer new];
    });
    return jsBridgeServer;
}

+ (NSString *)WebViewJavascriptBridgeInitCommand:(int )port identify:(NSString *)identify {
    return [NSString stringWithFormat:@"WebViewJavascriptBridge._init('%d','%@');",port,identify];
}

- (NSMutableDictionary *)callbacksQueue {
    if (_callbacksQueue == nil) {
        _callbacksQueue = [NSMutableDictionary dictionary];
    }
    return _callbacksQueue;
}

- (NSMutableDictionary *)handlersQueue {
    if (_handlersQueue == nil) {
        _handlersQueue = [NSMutableDictionary dictionary];
    }
    return _handlersQueue;
}

- (void)flushMessageQueue:(NSString *)msg {
    NSData *msgData = [NSData dataWithBytes:msg.UTF8String length:msg.length];
    NSError *error;
    NSDictionary *msgJson = [NSJSONSerialization JSONObjectWithData:msgData options:NSJSONReadingMutableLeaves error:&error];
    if (msgJson) {
        NSLog(@"RCV json: %@",msgJson);
        NSString* responseId = msgJson[@"responseId"];
        if (responseId) {
            JSBridgeWebsocketCallback cb = _callbacksQueue[responseId];
            dispatch_async(dispatch_get_main_queue(), ^{
                cb(msgJson[@"responseData"]);
            });
            [self.callbacksQueue removeObjectForKey:responseId];
            
        }else {
            NSString *callbackId = [msgJson objectForKey:@"callbackId"];
            JSBridgeWebsocketCallback cb = NULL;
            if (callbackId) {
                cb = ^void(id message) {
                    if ([message isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *toJSJson = [NSMutableDictionary dictionary];
                        [toJSJson setValue:callbackId forKey:@"responseId"];
                        [toJSJson setValue:message forKey:@"responseData"];
                        
                        [self sendMessage:toJSJson];
                    }
                };
            }
            
            JSBridgeWebsocketHandler handler = self.handlersQueue[msgJson[@"handlerName"]];
            if (!handler) {
                NSLog(@"No handler for message from JS: %@", msgJson);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(msgJson[@"data"], cb);
            });
        }
        
    }else {
        NSLog(@"RCV string: %@",msg);
    }
}

- (void)send:(id)data responseCallback:(JSBridgeWebsocketCallback)responseCallback handlerName:(NSString*)handlerName{
    NSMutableDictionary* message = [NSMutableDictionary dictionary];
    if (data) {
        message[@"data"] = data;
    }
    
    if (responseCallback) {
        NSString* callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
        self.callbacksQueue[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self sendMessage:message];
}
- (void)send:(id)data {
    [self send:data responseCallback:nil handlerName:nil];
}
- (void)callHandler:(NSString *)handlerName {
    [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(JSBridgeWebsocketCallback)responseCallback {
    [self send:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)registerHandler:(NSString *)handlerName handler:(JSBridgeWebsocketHandler)handler {
    self.handlersQueue[handlerName] = [handler copy];
}

- (void)removeHandler:(NSString *)handlerName {
    [self.handlersQueue removeObjectForKey:handlerName];
}

- (void)sendMessage:(NSDictionary *)message {
    NSError *error;
    NSString *messageStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
    if (error) {
        NSLog(@"class: %@ method:%@ line:%d error:%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd),__LINE__,error);
        return;
    }
    [self sendMessageStr:messageStr];
}
- (void)sendMessageStr:(NSString *)messageStr {
    [self.ws sendMessage:messageStr];
}



#pragma mark - WebSocketDelegate

- (void)webSocketDidOpen:(WebSocket *)ws {
    
}
- (void)webSocket:(WebSocket *)ws didReceiveMessage:(NSString *)msg {
    if ([ws isEqual:self.ws]) {
        [self flushMessageQueue:msg];
    }
}
- (void)webSocketDidClose:(WebSocket *)ws {

}
@end
