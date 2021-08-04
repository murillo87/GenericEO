////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       Review.m
/// @author     Lynette Sesodia
/// @date       1/6/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "Review.h"

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

@interface Review()

// Readonly object redefinition.
@property (nonatomic, readwrite, strong) ParseReview *parseReview;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation Review

@synthesize uuid = _uuid;
@synthesize text = _text;
@synthesize parentID = _parentID;
@synthesize authorID = _authorID;
@synthesize authorUsername = _authorUsername;
@synthesize upCount = _upCount;
@synthesize downCount = _downCount;
@synthesize starValue = _starValue;
@synthesize flagCount = _flagCount;

#pragma mark - Initialization

- (id)initWithParseReview:(ParseReview *)parseReview {
    self = [super init];
    if (self) {
        self.parseReview = parseReview;
    }
    return self;
}

#pragma mark - Getters/Setters

- (NSString *)uuid {
    return self.parseReview.uuid;
}

- (NSString *)text {
    return self.parseReview.text;
}

- (NSString *)parentID {
    return self.parseReview.parentID;
}

- (NSString *)authorID {
    return self.parseReview.authorID;
}

- (NSString *)authorUsername {
    return self.parseReview.authorUsername;
}

- (NSNumber *)upCount {
    return self.parseReview.upCount;
}

- (NSNumber *)downCount {
    return self.parseReview.downCount;
}

- (NSNumber *)starValue {
    return self.parseReview.starValue;
}

- (NSNumber *)flagCount {
    return self.parseReview.flagCount;
}


@end
