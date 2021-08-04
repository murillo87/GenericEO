////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       WriteReviewViewController.m
/// @author     Lynette Sesodia
/// @date       2/3/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLWriteReviewViewController.h"

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

@interface ESTLWriteReviewViewController () <UITextViewDelegate>

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// Main view containing noteTextView.
@property (nonatomic, strong) IBOutlet UIView *mainView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLWriteReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Add a nav bar item for saving
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self
                                   action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = btn;
}

#pragma mark - Actions

- (IBAction)save:(UIButton *)sender {
    // Prevent saving of default review
    if ([self.reviewTextView.text isEqualToString:DefaultText]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [super saveReview];
}

@end
