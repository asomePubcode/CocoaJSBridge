//
//  CocoaJSBridgeServer.h
//  CocoaJSBridge
//
//  Created by 廖亚雄 on 2019/5/15.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

@interface CocoaJSBridgeServer : NSObject
- (int) port;

- (BOOL) isRunnig;
@end

//NS_ASSUME_NONNULL_END
