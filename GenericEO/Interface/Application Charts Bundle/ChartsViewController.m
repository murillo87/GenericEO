////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ChartsViewController.m
/// @author     Lynette Sesodia
/// @date       5/18/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ChartsViewController.h"
#import "ABChartViewController.h"
#import "ESTLChartViewController.h"
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

@interface ChartsViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ChartsViewController

- (id)initWithObject:(PFObject *)object {
    
#ifdef AB
    self = [[ABChartViewController alloc] initWithObject:object];
#else
    self = [[ESTLChartViewController alloc] initWithObject:object];
#endif
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *imageStr = [self.object valueForKey:@"imageStr"];
    if (!imageStr || imageStr.length == 0) {
        self.imageHeight.constant = 0.0;
    }
    
    // Configure the views
    self.titleLabel.text = [self.object valueForKey:@"name"];
    
    self.descriptionLabel.text = [self.object valueForKey:@"text"];
    self.mainImage.image = [UIImage imageNamed:[self.object valueForKey:@"imageStr"]];
    
    self.imageScrollView.maximumZoomScale = 3.0;
    self.imageScrollView.delegate = self;
    self.imageScrollView.layer.cornerRadius = 22.;
    self.imageScrollView.layer.masksToBounds = YES;
    
    IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsViewedCharts];
    [event setValue:[NSString stringWithFormat:@"%@", self.object[@"name"]]
       forAttribute:AnalyticsNameAttribute];
    [[IPAAnalyticsManager sharedInstance] reportEvent:event];
}

#pragma mark - IBActions

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mainImage;
}

@end
