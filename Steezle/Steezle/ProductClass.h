//
//  ProductClass.h
//  Steezle
//
//  Created by webmachanics on 23/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductClass : NSObject

@property (nonatomic, copy) NSString *cater_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *regular_price;
@property (nonatomic, copy) NSString *sale_price;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *main_image;
@property (nonatomic, copy) NSMutableArray *imagesArray;
@property (nonatomic, copy) NSString *images;
@property (nonatomic,copy)  NSMutableArray *categories;
@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy)NSString *brandName;

@property (nonatomic, copy) NSString *imagestr;

//product Details wish list
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *product_price;
@property (nonatomic, copy) NSString *product_regular_price;
@property (nonatomic, copy) NSString *product_sale_price;
@property (nonatomic, copy) NSString *product_stock_status;
@property (nonatomic, copy) NSString *product_type;
@property (nonatomic, copy) NSString *fav_list_added_date;
@property (nonatomic, copy) NSString *product_image;

@end
