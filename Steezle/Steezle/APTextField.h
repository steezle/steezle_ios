//
//  APTextField.h
//  Steezle
//
//  Created by webmachanics on 10/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APTextField : UITextField
@property (nonatomic, strong, nullable) NSDictionary *placeholderAttributes;
@property (nonatomic, strong, nullable) UIColor *errorColor;
@property (nonatomic, strong, nullable) UIColor *lineColor;

- (void)showError;
- (void)hideError;
@property (nonatomic) IBInspectable BOOL enableMaterialPlaceHolder;
@end
