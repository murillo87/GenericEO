////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       RecipeListTableViewCell.m
/// @author     Lynette Sesodia
/// @date       5/22/18
//
//  Copyright © 2018 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "RecipesListTableViewCell.h"

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

@interface RecipesListTableViewCell()

/// Main view holding all other view elements. Has with rounded corners.
@property (nonatomic, strong) IBOutlet UIView *mainView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation RecipesListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mainView.layer.cornerRadius = 12.0;
    self.mainView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
