//
//  IR_UserResources.h
//  InviteReferrals
//
//  Created by Siddharth Gupta on 13/07/16.
//  Copyright © 2016 InviteReferrals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IR_UserResources : NSObject  


+(NSString *)IR_SetTextFieldsFontName;
+(float)IR_SetTextFieldsFontSize;
+(UIColor *)IR_SetTextFieldsBackgroundColor;
+(UIColor *)IR_SetTextFieldsTextColor;
+(UIColor *)IR_SetTextFieldsPlaceHolderTextColor;

+(NSString *)IR_SetNameTextFieldsPlaceholder;
+(NSString *)IR_SetEmailTextFieldsPlaceholder;
+(NSString *)IR_SetPhoneTextFieldsPlaceholder;

+(NSInteger)setMobileNumberMinLength;
+(NSInteger)setMobileNumberMaxLength;

+(UIColor *)IR_RegisterButtonBackgroundColor;
+(NSString *)IR_SetRegisterButtonText;
+(NSString *)IR_SetRegisterButtonTextFontName;
+(float)IR_SetRegisterButtonTextFontSize;
+(UIColor *)IR_SetRegisterButtonTextColor;
+(UIColor *)IR_RegisterButtonBorderColor;
+(float)IR_RegisterButtonBorderWidth;
+(float)IR_RegisterButtonBorderRadius;


+(float)IR_SetSharingLinkBoxBorderLineWidth;
+(UIColor *)IR_SetSharingLinkBoxBorderColor;
+(float)IR_SetSharingLinkBoxViewDividerWidth;
+(UIColor *)IR_SetSharingLinkBoxViewDividerColor;

+(UIImage *)IR_SetShareButtonImage;
+(NSString *)IR_SetSharingLinkFontName;
+(float)IR_SetSharingLinkFontSize;
+(UIColor *)IR_SetSharingLinkTextColor;

+(CGSize) IR_SetShareButtonsIconSize;

+(UIImage *)IR_SetWhatsAppShareButtonImage;
+(UIImage *)IR_SetSmsShareButtonImage;
+(UIImage *)IR_SetFacebookShareButtonImage;
+(UIImage *)IR_SetTwitterShareButtonImage;
+(UIImage *)IR_SetMailShareButtonImage;

+(void)HandleDoneButtonActionWithUserInfo:(NSMutableDictionary *)userInfo;

@end
