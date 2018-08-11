//
//  productDetailsClass.h
//  Steezle
//
//  Created by webmachanics on 10/10/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productDetailsClass : NSObject

@property (nonatomic, copy) NSString *variation_id;
@property (nonatomic, copy) NSString *variation_display_price;
@property (nonatomic, copy) NSString *variation_reguler_price;
@property (nonatomic, copy) NSString *qty;
@property (nonatomic, copy) NSString *is_in_stock;
@property (nonatomic, copy) NSString *availability_stock;
@property (nonatomic, copy) NSString *pa_color;
@property (nonatomic, copy) NSString *color_code;

@end
