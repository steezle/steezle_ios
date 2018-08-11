//
//  CatergoriesListVC.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CatergoriesListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *image_array, *label_array;
}
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic)NSString *product_id;

@property (strong, nonatomic) NSMutableArray *categorylistArray;
@property (strong, nonatomic) NSMutableArray *detailsArray;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLBL;
@property (weak,nonatomic)NSString *productTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *child_top_h;
- (IBAction)setting_act:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cart_countLBL;
- (IBAction)shopping_Act:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@end
