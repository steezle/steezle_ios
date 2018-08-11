//
//  Utils.m
//  VehicleCheck
//
//  Created by Aecor Digital on 17/01/17.
//  Copyright © 2017 Aecor Digital. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"

@implementation Utils

+(BOOL)isNetworkAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}
+(NSString *)getCurrentDateAndTimeSecond{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss d MMM yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *formattedDate =[dateFormatter stringFromDate:[NSDate date]];
    return formattedDate;
}
+(NSString *)getCurrentDateAndTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm d MMM yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *formattedDate =[dateFormatter stringFromDate:[NSDate date]];
    return formattedDate;
}

@end
