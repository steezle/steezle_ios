//
//  AboutVC.h
//  Steezle
//
//  Created by Ryan Smith on 2018-02-02.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ActBack;
- (IBAction)ActionBack:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top_h;

@end
