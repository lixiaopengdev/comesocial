const BroadcastActionType = Object.freeze({
    broadcastActionType_js: "broadcastActionType_js",
});

function BroadcastAction(actionName ,args) {
    this.actionType = BroadcastActionType.broadcastActionType_js;
    this.actionName = actionName;
    this.args = args;
}

/*
 // 创建 WebSocket 对象，参数为 WebSocket 服务器地址
 const socket = new WebSocket('ws://example.com/socketserver');

 // 监听 WebSocket 连接事件
 socket.addEventListener('open', function (event) {
   console.log('WebSocket 连接已建立');
 });

 // 监听 WebSocket 接收消息事件
 socket.addEventListener('message', function (event) {
   console.log('接收到消息：', event.data);
 });

 // 监听 WebSocket 关闭事件
 socket.addEventListener('close', function (event) {
   console.log('WebSocket 连接已关闭');
 });

 // 监听 WebSocket 错误事件
 socket.addEventListener('error', function (event) {
   console.error('WebSocket 连接错误');
 });
-=======================================================-
 // 引入 JavaScriptCore 框架
 #import <JavaScriptCore/JavaScriptCore.h>

 // 创建 JavaScript 上下文环境
 JSContext *context = [[JSContext alloc] init];

 // 加载 WebSocket 类库
 NSString *webSocketPath = [[NSBundle mainBundle] pathForResource:@"WebSocket" ofType:@"js"];
 NSString *webSocketScript = [NSString stringWithContentsOfFile:webSocketPath encoding:NSUTF8StringEncoding error:nil];
 [context evaluateScript:webSocketScript];

 // 创建 WebSocket 对象
 NSString *webSocketUrl = @"ws://example.com/socketserver";
 JSValue *webSocket = [context evaluateScript:[NSString stringWithFormat:@"new WebSocket('%@')", webSocketUrl]];

 // 监听 WebSocket 事件
 webSocket[@"onopen"] = ^(JSValue *event) {
     NSLog(@"WebSocket 连接已建立");
 };

 webSocket[@"onmessage"] = ^(JSValue *event) {
     NSString *message = [[event valueForKey:@"data"] toString];
     NSLog(@"接收到消息：%@", message);
 };

 webSocket[@"onclose"] = ^(JSValue *event) {
     NSLog(@"WebSocket 连接已关闭");
 };

 webSocket[@"onerror"] = ^(JSValue *event) {
     NSLog(@"WebSocket 连接错误");
 };

 function WebSocket(url) {
   // 创建 WebSocket 对象
   this.socket = new window.WebSocket(url);

   // 监听 WebSocket 事件
   this.socket.onopen = this.onopen.bind(this);
   this.socket.onmessage = this.onmessage.bind(this);
   this.socket.onclose = this.onclose.bind(this);
   this.socket.onerror = this.onerror.bind(this);
 }

 WebSocket.prototype.onopen = function (event) {
   console.log('WebSocket 连接已建立');
 };

 WebSocket.prototype.onmessage = function (event) {
   console.log('接收到消息：', event.data);
 };

 WebSocket.prototype.onclose = function (event) {
   console.log('WebSocket 连接已关闭');
 };

 WebSocket.prototype.onerror = function (event) {
   console.error('WebSocket 连接错误');
 };

 WebSocket.prototype.send = function (data) {
   this.socket.send(data);
 };

 WebSocket.prototype.close = function (code, reason) {
   this.socket.close(code, reason);
 };

 
 
 */
