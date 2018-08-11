//
//  FilterPro_VC.h
//  Steezle
//
//  Created by Ryan Smith on 2018-01-19.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRangeSlider.h"


@protocol SecondViewFilterControllerDelegate <NSObject>

@required
- (void)dataFromController:(NSMutableArray *)data;
@end
@interface FilterPro_VC : UIViewController<TTRangeSliderDelegate>

@property (nonatomic, weak) id<SecondViewFilterControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *data;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)act_apply:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *apply_BTN;
@property (weak, nonatomic) IBOutlet UIButton *Act_back;
@property (copy, nonatomic) NSMutableArray *filter_arr;
@property (copy, nonatomic) NSMutableArray *filter_Price;
@property (copy, nonatomic) NSString *CategoryID;
- (IBAction)Act_back:(id)sender;
@property (nonatomic, assign) BOOL FromShuffel;
@property (weak, nonatomic) IBOutlet UIView *slideView;

@property (weak, nonatomic) IBOutlet UILabel *minLbl;
@property (weak, nonatomic) IBOutlet UILabel *MaxLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top_h;

@end
