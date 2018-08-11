//
//  ReturnPolicyVC.h
//  Steezle
//
//  Created by Ryan Smith on 2018-03-28.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnPolicyVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)ActBack:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top_h;
@end
