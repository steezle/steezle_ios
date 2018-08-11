//
//  AppDelegate.h
//  Steezle
//
//  Created by Aecor Digital on 16/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Google/SignIn.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>
    
@property (strong, nonatomic) NSMutableArray *wish_product_id_array;
//@property (strong, nonatomic) NSMutableArray *favoriteProductArray;
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

