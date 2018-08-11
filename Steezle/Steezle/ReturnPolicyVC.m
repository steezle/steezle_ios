//
//  ReturnPolicyVC.m
//  Steezle
//
//  Created by Ryan Smith on 2018-03-28.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import "ReturnPolicyVC.h"

@interface ReturnPolicyVC ()

@end

@implementation ReturnPolicyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadHtmlString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_activityIndicator stopAnimating];
}

-(void)LoadHtmlString{
    
    //    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    //    [webView loadHTMLString:htmlString baseURL:nil];
    
    
//    NSString *urlAddress = @"http://mytestwork.com/steezle/faq_and_return_policy.html";
    NSString *urlAddress = @"http://steezle.ca/faq_and_return_policy.html";

    NSURL *url = [[NSURL alloc] initWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:requestObj];
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //Check which iPhone it is
    double screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        NSLog(@"All iPads");
    } else if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        if(screenHeight == 480)
        {
            NSLog(@"iPhone 4/4S");
            // smallFonts = true;
        } else if (screenHeight == 568)
        {
            
        } else if (screenHeight == 667)
        {
            NSLog(@"iPhone 6/6S");
        }
        else if (screenHeight == 736)
        {
            NSLog(@"iPhone 6+, 6S+");
        }
        else if (screenHeight == 812)
        {
            if (@available(iOS 11, *))
            {
                UIView *parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                parentView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:parentView];
                _Top_h.constant=40;
                
                
            } else {
                
            }
        }
        else
        {
            NSLog(@"Others");
        }
    }
}
- (IBAction)ActBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
