////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABFeedViewController.m
/// @author     Lynette Sesodia
/// @date       5/27/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "FeedViewController.h"
#import "ABFeedViewController.h"
#import "ESTLFeedViewController.h"

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

@interface FeedViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation FeedViewController

- (id)initForTarget {
#ifdef AB
    self = [[ABFeedViewController alloc] init];
#else
    self = [[ESTLFeedViewController alloc] init];
#endif
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
