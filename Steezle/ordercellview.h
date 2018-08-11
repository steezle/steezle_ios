//
//  ordercellview.h
//  Steezle
//
//  Created by webmachanics on 09/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ordercellview : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *status_image;
@property (weak, nonatomic) IBOutlet UILabel *order_idLBL;
@property (weak, nonatomic) IBOutlet UILabel *Order_Date;
@property (weak, nonatomic) IBOutlet UILabel *Total_PriceLBL;
@property (weak, nonatomic) IBOutlet UILabel *Total_iteams;
@property (weak, nonatomic) IBOutlet UIView *order_view;
- (IBAction)Actcancelled:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelledBTN;
@property (weak, nonatomic) IBOutlet UILabel *order_status;

@end
