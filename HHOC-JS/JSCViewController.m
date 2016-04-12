//
//  JSCViewController.m
//  HHOC-JS
//
//  Created by Hong on 16/2/1.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "JSCViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)callCamera;
- (void)share:(NSString *)shareString;

@end

@interface JSCViewController ()<UIWebViewDelegate , JSObjcDelegate>

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"jsc" ofType:@"html"]]]];
    
    [self initJsContext];
}

- (void)initJsContext
{
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"Toyun"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self webView];

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    self.jsContext[@"EmbedPlayer"] = self;
    //    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
    //        context.exception = exceptionValue;
    //        NSLog(@"异常信息：%@", exceptionValue);
    //    };
    
    NSLog(@"%s", __func__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __func__);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"%s", __func__);
}

#pragma mark - JSObjcDelegate

- (void)callCamera
{
    NSLog(@"callCamera");
    // 获取到照片之后在回调js的方法picCallback把图片传出去
    JSValue *picCallback = self.jsContext[@"picCallback"];
    [picCallback callWithArguments:@[@"photos"]];
}

- (void)share:(NSString *)shareString
{
    NSLog(@"share:%@", shareString);    // 分享成功回调js的方法shareCallback
    JSValue *shareCallback = self.jsContext[@"shareCallback"];
    [shareCallback callWithArguments:nil];
}

- (void)notifyPlayerReady
{
    NSLog(@"__%s__", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
