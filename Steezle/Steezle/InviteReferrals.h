//
//  Created by Siddharth Gupta
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Security/Security.h>
typedef void(^SharingDetails)(NSMutableDictionary* _Nullable);
typedef void(^validateReferralCode)(NSMutableDictionary* _Nullable);
typedef void(^TrackingCompletionHandler)(NSMutableDictionary *_Nullable);


@interface InviteReferrals : NSObject {
    NSTimer *setupCompleteTimer;
}
@property (nonatomic, strong) NSTimer * _Nullable setupCompleteTimer;
+ (void) setupWithBrandId:(int)brandId encryptedKey:(NSString*_Nonnull)encryptedKey;
+ (void) fetchSettings;
+ (void) fetchReferrerDetails:(NSString*_Nullable)mobile;
+ (void) setupUserID:(NSString*_Nullable)email mobile:(NSString*_Nullable)mobile name:(NSString*_Nullable)name gender:(NSString*_Nullable)gender shareLink:(NSString*_Nullable)shareLink shareTitle:(NSString*_Nullable)shareTitle shareDesc:(NSString*_Nullable)shareDesc shareImg:(NSString*_Nullable)shareImg customValue:(NSString*_Nullable)customValue campaignID:(NSString*_Nullable)campaignID flag:(NSString *_Nullable)flag SubscriptionID:(NSString *_Nullable)subscriptionID;
+ (void) launch:(NSString*_Nullable)campaignID Email:(NSString*_Nullable)email mobile:(NSString*_Nullable)mobile name:(NSString*_Nullable)name SubscriptionID:(NSString *_Nullable)subscriptionID;
+ (void) showSharePopup:(NSString*_Nullable)page Email:(NSString*_Nullable)email mobile:(NSString*_Nullable)mobile name:(NSString*_Nullable)name SubscriptionID:(NSString *_Nullable)subscriptionID;


+ (void) createSharePopup:(NSTimer *_Nullable)timer;
+ (void)popUpBtnClick:(id _Nullable )sender;
+ (void) welcomeMessage;
+ (void) welcomeMessagePopup:(NSMutableDictionary *_Nullable)data;
+ (void)tracking:(NSString*_Nullable)eventName orderID:(NSString*_Nullable)orderID purchaseValue:(NSString*_Nullable)purchaseValue email:(NSString *_Nullable)email mobile:(NSString *_Nullable)mobile name:(NSString *_Nullable)name referCode:(NSString *_Nullable)ReferCode uniqueCode:(NSString *_Nullable)unique_code isDebugMode:(BOOL)debugMode ComplitionHandler:(TrackingCompletionHandler _Nullable)complitionHandler;


//+ (void) tracking:(NSString*_Nullable)eventName orderID:(NSString*_Nullable)orderID purchaseValue:(NSString*_Nullable)purchaseValue email:(NSString *_Nullable)email mobile:(NSString *_Nullable)mobile name:(NSString *_Nullable)name referCode:(NSString *_Nullable)ReferCode uniqueCode:(NSString *_Nullable)unique_code isDebugMode:(BOOL)debugMode;
+(void)application:(UIApplication *_Nullable)application openURL:(NSURL *_Nullable)url sourceApplication:(NSString *_Nullable)sourceApplication annotation:(id   _Nullable )annotation;

+(void)UserDetails:(NSString*_Nullable)email mobile:(NSString*_Nullable)mobile name:(NSString*_Nullable)name gender:(NSString*_Nullable)gender shareLink:(NSString*_Nullable)shareLink shareTitle:(NSString*_Nullable)shareTitle shareDesc:(NSString*_Nullable)shareDesc shareImg:(NSString*_Nullable)shareImg customValue:(NSString*_Nullable)customValue campaignID:(NSString *_Nullable)campaignID flag:(NSString *_Nullable)flag SubscriptionID:(NSString *_Nullable)subscriptionID;


+(void)GetShareDataWithCampaignID:(NSString *_Nullable)campaignID Email:(NSString *_Nullable)email mobile:(NSString *_Nullable)mobile name:(NSString*_Nullable)name  SubscriptionID:(NSString *_Nullable)irSubscriptionID ShowErrorAlerts:(BOOL)irShowAlerts ShowActivityIndicatorViewWhileLoading:(BOOL)irShowActivityIndicator SharingDetails:(SharingDetails _Nullable)irSharingDetails;

//+(void)validateReferralCode:(NSString *_Nullable)irReferralCode ComplitionHandler:(validateReferralCode _Nullable)complitionHandler;
+ (BOOL)connected;
//+ (BOOL)ShoudTrackEvent:(NSString *_Nullable)eventName;
+(void)ErrorAlerts;
//+(void)trackInviteForAppName:(NSString *_Nullable)irSource;

+(void)setDefaultNavigationController:(UINavigationController *_Nullable)navController BarStyle:(UIBarStyle)navBarStyle PreferedStatusBarStyleLightContent:(BOOL)navCustomStatusBarStyleLightContent BarSetTranslucent:(BOOL)navSetBarTranslucent BarLoginScreenTitle:(NSString *_Nullable)navBarLoginScreenTitle BarShareScreenTitle:(NSString *_Nullable)navBarShareScreenTitle BarTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> * _Nullable)navBarTitleTextAttributes BarTitleColor:(NSString *_Nullable)navBarTitleColor BarBackground:(NSString *_Nullable)navBarBackground BarButtonPosition:(NSString *_Nullable)navBarButtonPosition BarButtonTitle:(NSString *_Nullable)navBarButtonTitle BarTextFontName:(NSString *_Nullable)navBarTextFontName BarTitleFontSize:(float)navBarTitleFontSize BarButtonTextAttributes:(NSDictionary<NSAttributedStringKey,id> * _Nullable)navBarButtonTextAttributes BarButtonFontSize:(float)navBarButtonFontSize BarButtonIconWidth:(float)navBarButtonIconWidth BarButtonIconHeight:(float)navBarButtonIconHeight BarButtonTintColor:(NSString *_Nullable)navBarButtonTintColor;
@end
