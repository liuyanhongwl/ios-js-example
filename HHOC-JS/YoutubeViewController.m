//
//  YoutubeViewController.m
//  HHOC-JS
//
//  Created by Hong on 16/2/1.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "YoutubeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)notifyPlayerReady;

@end

@interface YoutubeViewController ()<UIWebViewDelegate, JSObjcDelegate>

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.view addSubview:self.webView];
    
    [self initJsContext];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.dailycast.tv/v2/youtube_embeded/SHOBwfdr4AE"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}

- (void)initJsContext
{
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"EmbedPlayer"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息： %@", exceptionValue);
    };
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s---%@", __func__, webView.request.URL);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s---%@", __func__, webView.request.URL);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s---%@", __func__, webView.request.URL);

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"%s---%@", __func__, webView.request.URL);
}

#pragma mark - JSObjcDelegate

- (void)notifyPlayerReady
{
    NSLog(@"__%s___", __func__);
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
