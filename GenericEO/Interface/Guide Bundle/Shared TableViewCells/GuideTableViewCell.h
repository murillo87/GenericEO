////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       GuideTableViewCell.h
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

@interface GuideTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *name;

@property (nonatomic,strong) IBOutlet UILabel *subtitle;

@end
