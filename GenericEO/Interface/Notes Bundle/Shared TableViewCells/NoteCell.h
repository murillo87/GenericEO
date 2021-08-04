////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NoteCell.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
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

@interface NoteCell : UITableViewCell

/// Label displaying note's object name.
@property (nonatomic, strong) IBOutlet UILabel *noteNameLabel;

/// Label displaying the note's text.
@property (nonatomic, strong) IBOutlet UILabel *noteTextLabel;

@end
