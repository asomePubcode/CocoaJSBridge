//
//  StreamConnection.h
//  PerfectJSBridge
//
//  Created by 廖亚雄 on 2019/4/4.
//  Copyright © 2019 廖亚雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
NS_ASSUME_NONNULL_BEGIN
@class StreamWebsocket;
@interface StreamConnection : HTTPConnection
@property(nonatomic, strong) StreamWebsocket *ws;
@end

NS_ASSUME_NONNULL_END
