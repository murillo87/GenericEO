////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       OilModel.h
/// @author     Lynette Sesodia
/// @date       9/11/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>

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

@protocol OilModel <NSObject>

@required

/// The user facing string name of the oil object.
@property (nonatomic, strong) NSString *name;

/// The unique identifier for the oil.
@property (nonatomic, strong) NSString *uuid;

/// The user facing description of the oil.
@property (nonatomic, strong) NSString *summaryDescription;

/// The scientific name of the oil.
@property (nonatomic, strong) NSString *scientificName;

/// String description of the scent of the oil.
@property (nonatomic, strong) NSString *scent;

/// Precaution information about the oil.
@property (nonatomic, strong) NSString *precautionsText;

@end

NS_ASSUME_NONNULL_END
