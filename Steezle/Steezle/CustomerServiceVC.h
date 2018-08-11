//
//  CustomerServiceVC.h
//  Steezle
//
//  Created by Ryan Smith on 2018-05-02.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerServiceVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)ActBack:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top_h;
@end
