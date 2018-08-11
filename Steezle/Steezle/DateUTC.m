//
//  DateUTC.m
//  Faster Delivery
//
//  Created by Agnitio Mac2 on 21/03/17.
//  Copyright © 2017 Agnitio Software. All rights reserved.
//

#import "DateUTC.h"

@implementation DateUTC

+(NSString *)ChangeDateInUTC:(NSString*)JsonDate{
    NSString *DateInUTC;
    
    //NSString *myDateAsAStringValue = @"20140621-061250";
    
    //create the formatter for parsing
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //parsing the string and converting it to NSDate
    NSDate *myDate = [df dateFromString: JsonDate];
    
    //create the formatter for the output
    NSDateFormatter *out_df = [[NSDateFormatter alloc] init];
    [out_df setDateFormat:@"h:mm a 'on' MMM d,yyyy"];
//    [out_df setDateStyle:NSDateFormatterMediumStyle];
//    [out_df setDateFormat:@"yyyy-MM-dd"];
    
    //output the date
    DateInUTC =[out_df stringFromDate:myDate];
    
    NSLog(@"the date is %@",[out_df stringFromDate:myDate]);
    return DateInUTC;
}
+(NSString*)ChangeDateAndTimeInUTC:(NSString*)Jsontime
{
    NSString *DateInUTC;
    
    //NSString *myDateAsAStringValue = @"20140621-061250";
    
    //create the formatter for parsing
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //parsing the string and converting it to NSDate
    NSDate *myDate = [df dateFromString: Jsontime];
    
    //create the formatter for the output
    NSDateFormatter *out_df = [[NSDateFormatter alloc] init];
    [out_df setDateFormat:@"h:mm a dd MMMM yyyy "];
       //output the date
    DateInUTC =[out_df stringFromDate:myDate];
    
    NSLog(@"the date is %@",[out_df stringFromDate:myDate]);
    return DateInUTC;
}
+(NSString *)ChangeTimeInUTC:(NSString*)JsonTime{
   
    NSString *DateInUTC;
    
    //NSString *myDateAsAStringValue = @"20140621-061250";
    
    //create the formatter for parsing
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //parsing the string and converting it to NSDate
    NSDate *myDate = [df dateFromString: JsonTime];
    
    //create the formatter for the output
    NSDateFormatter *out_df = [[NSDateFormatter alloc] init];
    [out_df setTimeStyle:NSDateFormatterShortStyle];
//      [out_df setDateFormat:@"HH:mm"];
    
    //output the date
    DateInUTC =[out_df stringFromDate:myDate];
    
    NSLog(@"the date is %@",[out_df stringFromDate:myDate]);
    return DateInUTC;
}



+(NSString *)ChangeDateInLocal:(NSString*)JsonDate{
    NSString *DateInlocal;
//    NSDate *setdate;
    
    NSString *date = @"2017-03-21 10:30:16 +0000";
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date1 = [DateFormatter dateFromString:date];
    NSLog(@"%@",date1);
    
    
    //2017-03-21 16:00:16 ----- 2017-03-21 10:30:16 +0000
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [dateFormatter stringFromDate:date1];
    NSLog(@"stinrgn%@", stringDate);
    return DateInlocal;
}

//
//
//NSNumber *val = [NSNumber numberWithDouble:bpmDouble];
//NSDate* sourceDate = sample.startDate;
//NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
//NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
//NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
//NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//NSDate* now = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ:z"];
//
//NSString *MyString;
//
//MyString = [dateFormatter stringFromDate:now];
//
//
//NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//
//[dateFormatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ:z"];
//
//NSDate *date = [dateFormatter1 dateFromString:MyString];
//-(NSString *)RetunnDateInString:(NSDate*)setdate{
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    
//    [dateFormatter setDateFormat:@"HH:mm"];
//    NSString *stringDate = [dateFormatter stringFromDate:setdate];
//    NSLog(@"stinrgn%@", stringDate);
//    
//    return stringDate;
//}
//


//
//NSDate *date = [NSDate new];
//NSString *stin = [NSString stringWithFormat:@"%@",date];
//
//NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//NSString *dateString = [formatter stringFromDate:date];
//NSLog(@"%@ ----- %@ ",dateString ,stin);


@end
