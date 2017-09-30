//
//  JSCoreViewController.m
//  ios-js-example
//
//  Created by hong-drmk on 2017/9/29.
//  Copyright © 2017年 hong-drmk. All rights reserved.
//

#import "JSCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)callCamera;
- (void)share:(NSString *)shareString;

@end

@interface JSCoreViewController ()
<
UIWebViewDelegate,
JSObjcDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JSCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Use JavaScriptCore";
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"jsc" ofType:@"html"]]]];
    
    [self initJSContext];
}

- (void)initJSContext
{
    //获取js环境对象
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //把实现了 JSObjcDelegate 代理的方法封装成对象（BridgeObject）注入到 web 页面中
    self.jsContext[@"BridgeObject"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

#pragma mark JSObjcDelegate

//js 调用 oc
- (void)callCamera
{
    NSLog(@"%s", __FUNCTION__);
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)share:(NSString *)shareString
{
    NSLog(@"%s : %@", __FUNCTION__, shareString);
    
    //oc 调用 js 方法
    [self.jsContext evaluateScript:@"showAlert('Hello', 'JavaScriptCore')"];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //oc 调用 js 方法
    JSValue *showImage = self.jsContext[@"showImage"];
    NSString *URLString = [info[UIImagePickerControllerImageURL] absoluteString];
    [showImage callWithArguments:@[URLString]];
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
