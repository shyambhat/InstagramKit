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

@interface IKLoginViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation IKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.scrollView.bounces = NO;

    [self requestAuthorization];
}


- (void)requestAuthorization
{
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURLForScope:InstagramKitLoginScopePublicContent];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
}


#pragma mark - WebViewDelegate Methods -


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
    {
        // Automatically dismiss this webview
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"InstagramKit" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [self requestAuthorization];
    }
    
    return YES;
}


#pragma mark - IBAction Methods -


/**
 Method where we clean the HTTP Cookie and reload again the authorization URL.
 @discussion Help when the user goes to 'Forgot password' or other links inside the webview.
 */
- (IBAction)refreshAuthorizationURL:(id)sender
{
    [[InstagramEngine sharedEngine] logout];
    [self requestAuthorization];
}

@end
