//
//  OrderDetailsClass.h
//  Steezle
//
//  Created by Ryan Smith on 2017-12-07.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailsClass : NSObject

@property (nonatomic, copy) NSString *id_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, copy) NSString *subtotal;
@property (nonatomic, copy) NSString *subtotal_tax;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *variation_id;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *total_tax;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *count;
@end
