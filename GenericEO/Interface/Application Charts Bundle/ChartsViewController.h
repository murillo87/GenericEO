////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ChartsViewController.h
/// @author     Lynette Sesodia
/// @date       5/18/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseObjectViewControllerInitProtocol.h"

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
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface ChartsViewController : UIViewController <ParseObjectViewControllerInitProtocol, UIScrollViewDelegate>

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Back button for the view.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// The chart object displayed in the controller.
@property (nonatomic, strong) PFObject *object;

@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *mainImage;

@property (nonatomic, strong) IBOutlet UIScrollView *imageScrollView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *imageHeight;

- (IBAction)back:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
