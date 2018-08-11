//
//  AppDelegate.m
//  Steezle
//
//  Created by Aecor Digital on 16/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeTabBar.h"
#import "HomeView.h"
#import "HomePageVC.h"
#import "userdefaultArrayCall.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "InviteReferrals.h"
#import "LoginVC.h"
@import Stripe;


@interface AppDelegate ()
{
}
@end

@implementation AppDelegate
@synthesize wish_product_id_array;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            //facebook
            [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
//            [GIDSignIn sharedInstance].delegate = self;
//            NSError* configureError;
//            [[GGLContext sharedInstance] configureWithError: &configureError];
//            NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
        });
      
        [[STPPaymentConfiguration sharedConfiguration]  setPublishableKey:@"pk_live_ZG4KImX0bCskmlkf2tT5q6q4"];
//        [[STPPaymentConfiguration sharedConfiguration]  setPublishableKey:@"pk_test_uVBDZ0wJcJBrI8LGxY0BdKSH"];

        wish_product_id_array=[NSMutableArray new];
//        [InviteReferrals setupWithBrandId:21061 encryptedKey:@"42DF64F2445BC68132AD5D82BB5FA6B7"];
        
        [InviteReferrals setupWithBrandId:21608 encryptedKey:@"17E69721B7379F78A27F1772D36B8326"];
    //logged_in condition
        BOOL logged_in=[[NSUserDefaults standardUserDefaults] boolForKey:LOGGED_IN];
      
    if(logged_in)
    {
        
            [NSThread sleepForTimeInterval:2];
            UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
            nav.navigationBar.hidden=YES;
            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            
            window.rootViewController = nav;
            [window makeKeyAndVisible];
            self.window = window;

    }
    else
    {
        
            UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
            nav.navigationBar.hidden=YES;
            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.rootViewController = nav;
            [window makeKeyAndVisible];
            self.window = window;
       
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  
    [InviteReferrals application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    if ([url.absoluteString containsString:@"fb1396934647119692"]) {// facebook
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.absoluteString containsString:@"fb1396934647119692"]) {// facebook
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                        ];
        // Add any custom logic here.
        return handled;
    }else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
    
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
    {
//    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
//    NSString *email = user.profile.email;
//
//   NSLog(@"User _ID:%@",userId);
//   NSLog(@"id_Token:%@",idToken);
//   NSLog(@"Full_Name:%@",fullName);
//   NSLog(@"Given_Name:%@",givenName);
//   NSLog(@"Family_Name:%@",familyName);
//   NSLog(@"User_ID:%@",email);

}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application

{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
     [FBSDKAppEvents activateApp];
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;


- (NSPersistentContainer *)persistentContainer
{
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self)
    {
        if (_persistentContainer == nil)
        {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Steezle"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error)
            {
                if (error != nil)
                {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
       
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
