////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       TabBarViewController.m
/// @author     Lynette Sesodia
/// @date       7/25/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "TabBarViewController.h"
#import "ESTLFeedViewController.h"
#import "ESTLDataTableViewController.h"
#import "ABDataTableViewController.h"

#import "LoginViewController.h"

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

@interface TabBarViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef ESTL
    UIViewController *vc1 = [self addHomeViewControllerWithBaseIconNamed:@"home-outline" withSelectedIcon:@"home-fill"];
    
#elif AB
    UIViewController *vc1 = [[FeedViewController alloc] initForTarget];
    UIImage *image = [[UIImage imageNamed:@"tbi-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *selectedImage = [[UIImage imageNamed:@"tbi-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed"
                                                   image:image
                                           selectedImage:selectedImage];
    
#endif
    
    UIViewController *vc2 = [self addDataControllerForType:EODataTypeUsageGuide];
    UIViewController *vc3 = [self addDataControllerForType:EODataTypeSingleOil];
    UIViewController *vc4 = [self addDataControllerForType:EODataTypeRecipe];
    UIViewController *vc5 = [self addDataControllerForType:EODataTypeApplicationCharts];
    self.tabBar.tintColor = [UIColor targetAccentColor];
    self.viewControllers = @[vc1, vc2, vc3, vc4, vc5];
}

- (void)viewDidAppear:(BOOL)animated {
//    LoginViewController *vc = [[LoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.hidden = YES;
//    [self presentViewController:nav animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FeedViewController *)addHomeViewControllerWithBaseIconNamed:(NSString *)icon withSelectedIcon:(NSString *)selectedIcon {
    FeedViewController *home = [[FeedViewController alloc] initForTarget];
    home.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", nil)
                                                    image:[UIImage imageNamed:icon]
                                            selectedImage:[UIImage imageNamed:selectedIcon]];
    return home;
}

- (DataTableViewController *)addDataControllerForType:(EODataType)type {
    
    DataTableViewController *dataVC = [[DataTableViewController alloc] initWithType:type];
    
    NSString *title;
    NSString *key;
    
    switch (type) {
        case EODataTypeSingleOil:
        case EODataTypeSearchSingle:
            title = NSLocalizedString(@"Oils", nil);
            key = @"oil";
            break;
            
        case EODataTypeBlendedOil:
        case EODataTypeSearchBlend:
            title = NSLocalizedString(@"Oil Blends", nil);
            key = @"oil";
            break;
            
        case EODataTypeRecipe:
        case EODataTypeSearchRecipe:
            title = NSLocalizedString(@"Recipes", nil);
            key = @"recipe";
            break;
            
        case EODataTypeUsageGuide:
        case EODataTypeSearchGuide:
            title = NSLocalizedString(@"Guide", nil);
            key = @"guide";
            break;
            
        case EODataTypeApplicationCharts:
            title = NSLocalizedString(@"Charts", nil);
            key = @"hand";
            break;
            
        default:
            break;
    }
    
    
    
    UIImage *image, *selectedImage;
    
#ifdef AB
    NSString *str = [NSString stringWithFormat:@"tbi-%@", key];
    image = [[UIImage imageNamed:str] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    selectedImage = [[UIImage imageNamed:str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
#else
    NSString *outline = [NSString stringWithFormat:@"%@-outline", key];
    NSString *fill = [NSString stringWithFormat:@"%@-fill", key];
    
    image = [UIImage imageNamed:outline];
    selectedImage = [UIImage imageNamed:fill];
#endif
    
    dataVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                      image:image
                                              selectedImage:selectedImage];
    
    return dataVC;
}

@end
