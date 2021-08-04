////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABChartViewController.m
/// @author     Lynette Sesodia
/// @date       5/18/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABChartViewController.h"
#import "Constants.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABChartViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABChartViewController

- (id)initWithObject:(PFObject *)object {
    self = [super init];
    if (self) {
        self.object = object;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.font = [UIFont font:[UIFont titleFont] ofSize:19.0];
    self.backButton.tintColor = [UIColor targetAccentColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
