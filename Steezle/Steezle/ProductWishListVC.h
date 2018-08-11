//
//  ProductWishListVC.h
//  Steezle
//
//  Created by webmachanics on 23/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductWishListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (IBAction)ActioncheckOut:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *backAction;

- (IBAction)ActionBack:(id)sender;
- (IBAction)ActionShoppingNow:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *subAlertView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;
@property (weak, nonatomic) IBOutlet UILabel *cartcountLbl;
- (IBAction)act_setting:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@end
