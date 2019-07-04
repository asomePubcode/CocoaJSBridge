//
//  CocoaJSBridge_JS.m
//  CocoaJSBridge
//
//  Created by 廖亚雄 on 2019/4/8.
//

#import "CocoaJSBridge_JS.h"

NSString * CocoaJSBridge_js() {
#define __cjb_js_func__(x) #x
    
    // BEGIN preprocessorJSCode
    static NSString * preprocessorJSCode = @__cjb_js_func__(
                                                             ;(function() {
        if (window.WebViewJavascriptBridge) {
            return;
        }
        
        if (!window.onerror) {
            window.onerror = function(msg, url, line) {
                console.log("CocoaJSBridge: ERROR:" + msg + "@" + url + ":" + line);
            }
        }
        window.WebViewJavascriptBridge = {
            registerHandler: registerHandler,
            callHandler: callHandler,
            _init,_init
        };
        
        var messagingIframe;
        var sendMessageQueue = [];
        var messageHandlers = {};
        
//        var CUSTOM_PROTOCOL_SCHEME = 'https';
//        var QUEUE_HAS_MESSAGE = '__wvjb_queue_message__';
        
        var responseCallbacks = {};
        var uniqueId = 1;
//        var dispatchMessagesWithTimeoutSafety = true;
        var websocket;
        function _init(port,identify) {
//        function _init() {
            url = "ws://localhost:"+port+"/jsbridge?identify="+identify;
//            url = "ws://localhost:6565/jsbridge";
//            url = "ws://localhost:"+port+"/"+identify;
            websocket = new WebSocket(url);
            console.log("JS websocket init");
            websocket.onopen = function(event) {
                console.log("Connection open ...",event);
                websocket.send("Hello WebSockets!");
            };
            websocket.onclose = function(event) {
                console.log("Connection closed.",event);
            };
            websocket.onerror = function(event) {
                console.log("Connection error.",event);
            };
            websocket.onmessage = function(event) {
                console.log("Received Message: ",event);
                if(typeof event.data === 'string') {
                    var message;
                    try{
                        message = JSON.parse(event.data);
                    } catch(error) {
                        console.log("JSON.parse error:",error);
                        message = event.data;
                    }
                    if (typeof message === 'string') {
                        console.log("RECEIVE STRING:", message);
                        return;
                    }
                    var messageHandler;
                    var responseCallback;
                    if (message.responseId) {
                        responseCallback = responseCallbacks[message.responseId];
                        if (!responseCallback) {
                            return;
                        }
                        responseCallback(message.responseData);
                        delete responseCallbacks[message.responseId];
                    } else {
                        if (message.callbackId) {
                            var callbackResponseId = message.callbackId;
                            responseCallback = function(responseData) {
                                _doSend({ handlerName:message.handlerName, responseId:callbackResponseId, responseData:responseData });
                            };
                        }

                        var handler = messageHandlers[message.handlerName];
                        if (!handler) {
                            console.log("WebViewJavascriptBridge: WARNING: no handler for message from ObjC:", message);
                        } else {
                            handler(message.data, responseCallback);
                        }
                    }
                }else if(typeof event.data === 'ArrayBuffer'){
                    var buffer = event.data;
                    console.log("Received arraybuffer:",buffer);
                }
            };
        }
        function registerHandler(handlerName, handler) {
            console.log("registerHandler:",handlerName);
            messageHandlers[handlerName] = handler;
        }
        
        function callHandler(handlerName, data, responseCallback) {
            if (arguments.length == 2 && typeof data == 'function') {
                responseCallback = data;
                data = null;
            }
            console.log("callHandler.");
            _doSend({ handlerName:handlerName, data:data }, responseCallback);
        }
        
        function _doSend(message, responseCallback) {
            if (responseCallback) {
                var callbackId = 'cb_'+(uniqueId++)+'_'+new Date().getTime();
                responseCallbacks[callbackId] = responseCallback;
                message['callbackId'] = callbackId;
            }
            var messageQueueString = JSON.stringify(message);
            console.log("_doSend.",messageQueueString);
            websocket.send(messageQueueString)
        }
        
    messagingIframe = document.createElement('iframe');
    messagingIframe.style.display = 'none';
    messagingIframe.src = 'https' + '://' + '__bridge_init__/';
    document.documentElement.appendChild(messagingIframe);
        
    setTimeout(_callWVJBCallbacks, 0);
    function _callWVJBCallbacks() {
        var callbacks = window.WVJBCallbacks;
        delete window.WVJBCallbacks;
        for (var i=0; i<callbacks.length; i++) {
            callbacks[i](WebViewJavascriptBridge);
        }
    }
})();
        
        ); // END preprocessorJSCode
    
#undef __cjb_js_func__
    return preprocessorJSCode;
};
