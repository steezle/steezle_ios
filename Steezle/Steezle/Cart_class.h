//
//  Cart_class.h
//  Steezle
//
//  Created by webmachanics on 06/10/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart_class : NSObject
 
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *product_title;
@property (nonatomic, copy) NSString *qty;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *regular_price;
@property (nonatomic, copy) NSString *sale_price;
@property (nonatomic, copy) NSString *variation_id;
@property (nonatomic, copy) NSString *pa_size;
@property (nonatomic, copy) NSString *pa_color;
@property (nonatomic, copy) NSString *product_image;
@property (nonatomic, copy) NSString *brand_name;



@end
