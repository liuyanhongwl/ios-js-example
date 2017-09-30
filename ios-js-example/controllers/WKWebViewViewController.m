//
//  WKWebViewViewController.m
//  ios-js-example
//
//  Created by hong-drmk on 2017/9/30.
//  Copyright © 2017年 hong-drmk. All rights reserved.
//

#import "WKWebViewViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewViewController ()
<
WKUIDelegate,
WKScriptMessageHandler,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Use WKWebView";
    
    /*
     注入 js
     这块 js 代码的意思自适应网页大小，因为 WKWebView 不支持 scalesPageToFit 属性，
     去掉这块代码，页面会变得很小。
     */
    NSString *js = @"var meta = document.createElement('meta'); \
                    meta.setAttribute('name', 'viewport'); \
                    meta.setAttribute('content', 'width=device-width'); \
                    document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addUserScript:script];

    /*
     把 oc 可响应的 name 注入到 web 页面中
     在 js 中可以通过下面方式调用：
     window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
     */
    [configuration.userContentController addScriptMessageHandler:self name:@"callCamera"];

    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.frame) - 40) configuration:configuration];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"wkjs" ofType:@"html"]]]];
    
    
    UIView *tools = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), CGRectGetWidth(self.view.frame), 40)];
    tools.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tools];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"get web title" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tools addSubview:button];
}

- (void)buttonAction:(UIButton *)button {
    //注入 js
    NSString *js = @"document.title";
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"<--start-->complete get web title");
        NSLog(@"result: %@, error: %@", result, error);
        NSLog(@"<--end-->complete get web title");
    }];
}

#pragma mark WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"callCamera"]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //oc 调用 js 方法
    NSString *URLString = [info[UIImagePickerControllerImageURL] absoluteString];
    NSString *js = [NSString stringWithFormat:@"showImage('%@')", URLString];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"<--start-->complete showImage");
        NSLog(@"result: %@, error: %@", result, error);
        NSLog(@"<--end-->complete showIMage");
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
