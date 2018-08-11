//
//  SettingVC.h
//  Steezle
//
//  Created by webmachanics on 04/10/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingVC : UIViewController
- (IBAction)ActionBack:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)ActionLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBTN;

@end
