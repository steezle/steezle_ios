//
//  LastAddToBagBtnCell.h
//  Steezle
//
//  Created by Bhaumik Joshi on 27/05/18.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastAddToBagBtnCell : UITableViewCell
- (IBAction)wishBtnClick:(id)sender;
- (IBAction)addToBagBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *wishBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
