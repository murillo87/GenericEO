////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NoteCell.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "NoteCell.h"
#import "UIFont+Targets.h"

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

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation NoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.noteNameLabel.font = [UIFont boldTextFont];
    self.noteTextLabel.font = [UIFont textFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
