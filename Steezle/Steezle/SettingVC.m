//
//  SettingVC.m
//  Steezle
//
//  Created by webmachanics on 04/10/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "SettingVC.h"
#import "settingCell.h"
#import "userdefaultArrayCall.h"
#import "HomePageVC.h"
@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *detailsArray;
    NSMutableArray *imageArray;
}
@end

@implementation SettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableview.delegate=self;
    _tableview.dataSource=self;
    

    detailsArray=[NSMutableArray new];
    imageArray=[NSMutableArray new];
    
    [imageArray addObject:@"address_icon"];
    [imageArray addObject:@"payment_cart"];
    [imageArray addObject:@"contact_icon"];
    [imageArray addObject:@"favorite_icon"];
    [imageArray addObject:@"about_icon"];
    

    [detailsArray addObject:@"Address"];
    [detailsArray addObject:@"Payment cart"];
    [detailsArray addObject:@"Contact"];
    [detailsArray addObject:@"Favorites"];
    [detailsArray addObject:@"About"];
    
    _emailLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL]];
    
    
    self.logoutBTN.layer.borderWidth=0.2;
    self.logoutBTN.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.logoutBTN.layer.shadowRadius  = 1.0f;
    self.logoutBTN.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.logoutBTN.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.logoutBTN.layer.shadowOpacity = 0.1f;
    self.logoutBTN.layer.masksToBounds = YES;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.logoutBTN.bounds, shadowInsets)];
    self.logoutBTN.layer.shadowPath    = shadowPath.CGPath;

    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ActionBack:(id)sender {
    
//    [self dismissViewControllerAnimated:NO completion:nil];
      [self.navigationController popViewControllerAnimated:TRUE];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    settingCell *cell = (settingCell*)[tableView dequeueReusableCellWithIdentifier:@"cellsetting"];
    
    cell.image.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.nameLbl.text=[NSString stringWithFormat:@"%@",[detailsArray objectAtIndex:indexPath.row]];
    
    cell.cellview.layer.cornerRadius=8;
    cell.cellview.layer.shadowRadius  = 3.0f;
    cell.cellview.layer.shadowColor   = [UIColor blackColor].CGColor;
    cell.cellview.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    cell.cellview.layer.shadowOpacity = 0.2f;
    cell.cellview.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(cell.cellview.bounds, shadowInsets)];
    cell.cellview.layer.shadowPath    = shadowPath.CGPath;
    
    //    cell.image.image = [UIImage imageNamed: [image_array objectAtIndex:indexPath.row]];
    //    cell.lbl.text = [label_array objectAtIndex:indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    catergoriesClass *catergories_calss = nil;
    //    catergories_calss = [_detailsArray objectAtIndex:indexPath.row];
    //    NSString *product_id=[NSString stringWithFormat:@"%@",catergories_calss.cater_id];
    //
    NSLog(@"%ld",(long)indexPath.row);
    
    if(indexPath.row==0)
    {
        NSLog(@"%ld",(long)indexPath.row);
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
//        AddressVC *address = (AddressVC *)[storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];

//        [self presentViewController:address animated:NO completion:nil];
        
//        [self.navigationController pushViewController:address animated:YES];
    }
    else
    {
        NSLog(@"%ld",(long)indexPath.row);
    }
   
}
- (IBAction)ActionLogout:(id)sender
{
  
}
@end
