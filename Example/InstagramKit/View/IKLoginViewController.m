//
//    Copyright (c) 2015 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IKLoginViewController.h"
#import "InstagramKit.h"
#import <WebKit/WebKit.h>

@interface IKLoginViewController () <WKNavigationDelegate>

@end

@implementation IKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    webConfiguration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webConfiguration];
    webView.scrollView.bounces = NO;
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];

    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURLForScope:InstagramKitLoginScopePublicContent];
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL];
    [self.view addSubview:webView];
    [webView loadRequest:request];
}

- (void)authenticationSuccess
{
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:navigationResponse.response.URL error:&error]) {
        [self authenticationSuccess];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:navigationAction.request.URL error:&error]) {
        [self authenticationSuccess];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSURL *failingURL = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:failingURL error:&error])
    {
        [self authenticationSuccess];
    }
}
@end
