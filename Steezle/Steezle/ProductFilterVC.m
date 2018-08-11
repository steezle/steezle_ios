//
//  ProductFilterVC.m
//  Steezle
//
//  Created by Aecor Digital on 14/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "ProductFilterVC.h"

@interface ProductFilterVC ()

@end

@implementation ProductFilterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)selectBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
