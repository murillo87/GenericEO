////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLChartViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLChartViewController.h"
#import "GuideTableViewCell.h"
#import "AddNoteViewController.h"
#import "Constants.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kGuideCell @"GuideTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ESTLChartViewController () <UIScrollViewDelegate>

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLChartViewController

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
    
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeApplicationCharts];
    self.titleLabel.font = [UIFont font:[UIFont headerFont] ofSize:30.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
