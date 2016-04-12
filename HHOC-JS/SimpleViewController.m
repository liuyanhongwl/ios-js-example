
//
//  SimpleViewController.m
//  HHOC-JS
//
//  Created by Hong on 16/1/29.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()<UIWebViewDelegate>

@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"simple" ofType:@"html"]]]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __func__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"showAlert(123)"];
    
    NSLog(@"%s", __func__);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"%s", __func__);
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
