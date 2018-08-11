//
//  Utils.h
//  VehicleCheck
//
//  Created by Aecor Digital on 17/01/17.
//  Copyright © 2017 Aecor Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CoreLocation/CoreLocation.h>

@interface Utils : NSObject<CLLocationManagerDelegate>
+(BOOL)isNetworkAvailable;
+(NSString *)getCurrentDateAndTime;
+(NSString *)getCurrentDateAndTimeSecond;
//+(bool)isNetwork;
@end
