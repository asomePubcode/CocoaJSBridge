//
//  CJViewController.h
//  CocoaJSBridge
//
//  Created by 448654003@qq.com on 04/08/2019.
//  Copyright (c) 2019 448654003@qq.com. All rights reserved.
//

@import UIKit;

@interface CJViewController : UIViewController
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *filepath;

- (void) newMessage:(NSDictionary *)data;
@end
