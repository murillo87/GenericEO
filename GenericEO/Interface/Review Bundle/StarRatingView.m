////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       StarRatingView.m
/// @author     Lynette Sesodia
/// @date       2/3/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "StarRatingView.h"

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

@interface StarRatingView()

/// First star button.
@property (nonatomic, strong) IBOutlet UIButton *firstStarButton;

/// Second star button.
@property (nonatomic, strong) IBOutlet UIButton *secondStarButton;

/// Third star button.
@property (nonatomic, strong) IBOutlet UIButton *thirdStarButton;

/// Fourth star button.
@property (nonatomic, strong) IBOutlet UIButton *fourthStarButton;

/// Fifth star button.
@property (nonatomic, strong) IBOutlet UIButton *fifthStarButton;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation StarRatingView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadNib];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadNib];
    }
    return self;
}

- (void)loadNib {
    //Get nib from file
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"StarRatingView" owner:self options:nil];
    UIView *view = [xibs firstObject];
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self layoutIfNeeded];
}

- (void)setRating:(int)rating {
    NSArray *starButtons = [self starButtonsArray];
    
    // Loop through each button
    for (int i=0; i<starButtons.count; i++) {
        UIButton *button = starButtons[i];
        
        // If the rating is higher than the button index fill in the star
        if (rating > i) {
            [button setImage:[UIImage imageNamed:@"single-star"] forState:UIControlStateNormal];
        } else {
            [button setImage:[UIImage imageNamed:@"single-star-empty"] forState:UIControlStateNormal];
        }
    }
    
    // Set the current rating (adjust for any out of bounds ratings)
    if (rating < 0) rating = 0;
    if (rating > 5) rating = 5;
    self.currentRating = rating;
}

- (IBAction)tappedButtonOne:(id)sender {
    [self setRating:1];
}

- (IBAction)tappedButtonTwo:(id)sender {
    [self setRating:2];
}

- (IBAction)tappedButtonThree:(id)sender {
    [self setRating:3];
}

- (IBAction)tappedButtonFour:(id)sender {
    [self setRating:4];
}

- (IBAction)tappedButtonFive:(id)sender {
    [self setRating:5];
}

- (NSArray<UIButton *> *)starButtonsArray {
    return @[_firstStarButton, _secondStarButton, _thirdStarButton, _fourthStarButton, _fifthStarButton];
}

@end
