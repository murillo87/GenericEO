////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABWriteReviewViewController.m
/// @author     Lynette Sesodia
/// @date       7/22/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABWriteReviewViewController.h"

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

@interface ABWriteReviewViewController ()

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABWriteReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.font = [UIFont headerFont];
    
    if (self.savedReview != nil) {
        self.titleLabel.text = NSLocalizedString(@"Edit Review", nil);
    } else {
        self.titleLabel.text = NSLocalizedString(@"Create Review", nil);
    }
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    self.saveButton.tintColor = [UIColor targetAccentColor];

}

- (IBAction)save:(UIButton *)sender {
    // Prevent saving of default review
    if ([self.reviewTextView.text isEqualToString:DefaultText]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [super saveReview];
}

@end
