////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       DataTableViewControllerDelegate.h
/// @author     Lynette Sesodia
/// @date       4/30/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import "NetworkManager.h"


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

@protocol DataTableViewControllerSearchDelegate

/// Informs the delegate that a searched for PFObject has been selected.
- (void)searchControllerDidSelecteObject:(PFObject *)object;

@end

NS_ASSUME_NONNULL_END
