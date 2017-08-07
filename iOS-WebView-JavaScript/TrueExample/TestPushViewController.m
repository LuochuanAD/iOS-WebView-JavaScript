//
//  TestPushViewController.m
//  iOS-WebView-JavaScript
//
//  Created by 罗川 on 2017/8/7.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "TestPushViewController.h"

@interface TestPushViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation TestPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_urlString.length>0) {
        _webView=[[UIWebView alloc]initWithFrame:self.view.frame];
        _webView.delegate=self;
        _webView.scalesPageToFit=YES;
        [self.view addSubview:_webView];
        self.title=@"正在加载,稍等";
        NSURL *url=[NSURL URLWithString:_urlString];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        
    }else{
        if (_pushFromButton.length>0) {
            self.title=_pushFromButton;
        }
    }
    
    
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str=[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title=str;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
