////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PermissionRequestView.h
/// @author     Lynette Sesodia
/// @date       3/15/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

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

@interface TextFieldRequestView : UIView

/// Description label for the view.
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

/// User input textfield for the view.
@property (nonatomic, strong) IBOutlet UITextField *textField;

/// Status icon for textfield text.
@property (nonatomic, strong) IBOutlet UIImageView *statusIconImageView;

- (id)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

- (id)init NS_UNAVAILABLE;
- (id)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
