//
//  JSAndUIWebViewInteractionViewController.m
//  iOS-WebView-JavaScript
//
//  Created by 罗川 on 2017/8/7.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "JSAndUIWebViewInteractionViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "TestPushViewController.h"
@interface JSAndUIWebViewInteractionViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation JSAndUIWebViewInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 80, 30);
    [rightButton setTitle:@"切换传参数" forState:UIControlStateNormal];
    rightButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    rightButton.selected=NO;
    [rightButton addTarget:self action:@selector(exchangeValue:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundColor=[UIColor grayColor];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    _webView=[[UIWebView alloc]initWithFrame:self.view.frame];
    _webView.delegate=self;
    _webView.scalesPageToFit=YES;
    [self.view addSubview:_webView];
    [self loadHtml:@"total"];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
[_webView stringByEvaluatingJavaScriptFromString:@"getRequest(\"0\")"];
}
//此处模拟传不同参数给h5,进行ajax请求
- (void)exchangeValue:(UIButton *)button{
    button.selected=!button.selected;
    if (button.selected) {
       [_webView stringByEvaluatingJavaScriptFromString:@"getRequest(\"1\")"];
    }else{
        [_webView stringByEvaluatingJavaScriptFromString:@"getRequest(\"0\")"];
    }

}
-(void)loadHtml:(NSString*)name{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:name ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str=[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    (str.length>0)?(self.title=str):(self.title=@"交互实例");
    
    JSContext *content=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    content[@"getTo"]=^(){
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsStr in args) {
            NSLog(@"%@",jsStr);
            NSString *jsVal=[NSString stringWithFormat:@"%@",jsStr];
            TestPushViewController *testPushVC=[[TestPushViewController alloc]init];
            
            if([jsVal isEqualToString:@"one"]){
                testPushVC.pushFromButton=@"按钮一要跳转的页面";
            }else if ([jsVal isEqualToString:@"two"]){
                testPushVC.pushFromButton=@"按钮二要跳转的页面";
            }
            else if ([jsVal isEqualToString:@"three"]){
                testPushVC.pushFromButton=@"按钮三要跳转的页面";
            
            }
            [self.navigationController pushViewController:testPushVC animated:YES];
        }
        
    };
    content[@"getToUnknow"]=^(){
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSString *webUrl=[NSString stringWithFormat:@"%@",jsVal];
            NSLog(@"%@",webUrl);
            if (webUrl.length>0) {
                TestPushViewController *testPushVC=[[TestPushViewController alloc]init];
                testPushVC.urlString=webUrl;
                [self.navigationController pushViewController:testPushVC animated:YES];
                
            }
        }
        
    };
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
