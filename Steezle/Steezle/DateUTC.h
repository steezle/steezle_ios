//
//  DateUTC.h
//  Faster Delivery
//
//  Created by Agnitio Mac2 on 21/03/17.
//  Copyright © 2017 Agnitio Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUTC : NSObject
+(NSString *)ChangeDateInUTC:(NSString*)JsonDate;
+(NSString *)ChangeDateInLocal:(NSString*)JsonDate;
+(NSString *)ChangeTimeInUTC:(NSString*)JsonTime;
+(NSString*)ChangeDateAndTimeInUTC:(NSString*)Jsontime;


@end
