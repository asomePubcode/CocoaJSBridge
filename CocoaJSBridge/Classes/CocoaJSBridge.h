//
//  CocoaJSBridge.h
//  CocoaJSBridge
//
//  Created by 廖亚雄 on 2019/7/3.
//

#import <Foundation/Foundation.h>

extern NSString *const kBridgeLoad;
extern NSString *const kBridgeInit;

typedef void (^JSBridgeWebsocketCallback)(id response);
typedef void (^JSBridgeWebsocketHandler)(id data,JSBridgeWebsocketCallback callback);


@interface CocoaJSBridge : NSObject

@property(nonatomic, copy, readonly) NSString *identify;
@property(nonatomic, assign, readonly) int port;

- (instancetype)initWithIdentify:(NSString*)identify;

+ (NSString *)WebViewJavascriptBridgeInitCommand:(int )port identify:(NSString *)identify;

- (void)send:(id)data responseCallback:(JSBridgeWebsocketCallback)responseCallback handlerName:(NSString*)handlerName;
- (void)send:(id)data ;
- (void)callHandler:(NSString *)handlerName;
- (void)callHandler:(NSString *)handlerName data:(id)data ;
- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(JSBridgeWebsocketCallback)responseCallback ;

- (void)registerHandler:(NSString *)handlerName handler:(JSBridgeWebsocketHandler)handler;

- (void)removeHandler:(NSString *)handlerName;
@end
