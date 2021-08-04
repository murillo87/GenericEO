////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       IAPProduct.m
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "IAPProduct.h"
#import "Constants.h"
#import "SimpleKeychain.h"

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

@interface IAPProduct()

/// Readonly property reassignments.
@property (nonatomic, strong, readwrite) NSString *uuid;
@property (nonatomic, readwrite) IAPProductType type;
@property (nonatomic, readwrite) IAPProductStatus status;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation IAPProduct

#pragma mark - Intializers

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Unsupported initalizer use `initWithIdentifier:type:status:` instead"
                                 userInfo:nil];
    return [self initWithIdentifier:@"" type:0 status:0];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Unsupported initalizer use `initWithIdentifier:type:status:` instead"
                                 userInfo:nil];
    return [self initWithIdentifier:@"" type:0 status:0];
}

- (id)initWithIdentifier:(NSString *)uuid type:(IAPProductType)type status:(IAPProductStatus)status {
    self = [super init];
    if (self) {
        _uuid = uuid;
        _type = type;
        _status = status;
    }
    return self;
}

#pragma mark -

- (void)updateStatus:(IAPProductStatus)status {
    self.status = status;
}

@end
