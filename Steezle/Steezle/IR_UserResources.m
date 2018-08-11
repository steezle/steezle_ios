//
//  IR_UserResources.m
//  InviteReferrals
//
//  Created by Siddharth Gupta on 13/07/16.
//  Copyright © 2016 InviteReferrals. All rights reserved.
//@"Courier-Bold"

#import "IR_UserResources.h"

@implementation IR_UserResources
/* //  Start Customisation on Login Screen (set values here if you use this Screen)  */

+(NSString *)IR_SetTextFieldsFontName {
    return nil;
}
+(float)IR_SetTextFieldsFontSize {
    return 0;
}
+(UIColor *)IR_SetTextFieldsBackgroundColor {
    return nil;
}
+(UIColor *)IR_SetTextFieldsTextColor{
    return nil;
}
+(UIColor *)IR_SetTextFieldsPlaceHolderTextColor {
    return nil;
}
+(NSString *)IR_SetNameTextFieldsPlaceholder {
    return nil;
}
+(NSString *)IR_SetEmailTextFieldsPlaceholder {
    return nil;
}
+(NSString *)IR_SetPhoneTextFieldsPlaceholder {
    return nil;
}


+(NSInteger)setMobileNumberMinLength {
    return 10;
}
+(NSInteger)setMobileNumberMaxLength {
    return 10;
}

+(UIColor *)IR_RegisterButtonBackgroundColor {
    return nil;
}
+(NSString *)IR_SetRegisterButtonText {
    return nil;
}
+(NSString *)IR_SetRegisterButtonTextFontName {
    return nil;
}
+(float)IR_SetRegisterButtonTextFontSize {
    return 0;
}
+(UIColor *)IR_SetRegisterButtonTextColor {
    return nil;
}
+(UIColor *)IR_RegisterButtonBorderColor {
    return nil;
}
+(float)IR_RegisterButtonBorderWidth {
    return 0;
}
+(float)IR_RegisterButtonBorderRadius {
    return 0;
}

/* //  End of Customisation on Login Screen */

/* //  Start Customisation on Share Screen (set values here for your Sharing Screen coponents)  */



+(UIImage *)IR_SetWhatsAppShareButtonImage {
    return nil;
}

+(UIImage *)IR_SetSmsShareButtonImage {
    return nil;
}
+(UIImage *)IR_SetFacebookShareButtonImage {
    return nil;
}

+(UIImage *)IR_SetTwitterShareButtonImage {
    return nil;
}

+(UIImage *)IR_SetMailShareButtonImage {
    return nil;
}


+(float)IR_SetSharingLinkBoxBorderLineWidth {
    return 0;
}

+(UIColor *)IR_SetSharingLinkBoxBorderColor {
    return nil;
}

+(float)IR_SetSharingLinkBoxViewDividerWidth {
    return 0;
}
+(UIColor *)IR_SetSharingLinkBoxViewDividerColor {
    return nil;
}
+(UIImage *)IR_SetShareButtonImage {
    return nil;
}
+(NSString *)IR_SetSharingLinkFontName {
    return nil;
}
+(float)IR_SetSharingLinkFontSize {
    return 0;
}
+(UIColor *)IR_SetSharingLinkTextColor {
    return nil;
}

+(NSString *)IR_SetReferralsStatsButtonText {
    return nil;
}
+(NSString *)IR_SetReferralsStatsButtonFontName {
    return nil;
}

+(float)IR_SetReferralsStatsButtonFontSize {
    return 0;
}
+(float)IR_SetReferralsStatsButtonTopMargin {
    return 0;
}
+(UIColor *)IR_SetReferralsStatsButtonTextColor {
    return nil;
}

+(CGSize) IR_SetShareButtonsIconSize {
    return CGSizeZero;
}


/* //  End of Customisation on Share Screen */

/* // Start General Call Back Functions (Optional use these if you required only ) */

+(void)HandleDoneButtonActionWithUserInfo:(NSMutableDictionary *)userInfo {
    /* --------
     Do your stuff for Done button callback."
     --------------*/
}
/* // End of General Call Back Functions*/
@end
