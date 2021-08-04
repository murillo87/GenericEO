////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       AddNoteViewController.h
/// @author     Lynette Sesodia
/// @date       7/29/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyNotes+CoreDataClass.h"

#import "CoreDataManager.h"
#import "Constants.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static NSString * _Nonnull const DefaultNote = @"Write your note here.";
static CGFloat AddNoteBottomMargin = 8.0;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface AddNoteViewController : UIViewController

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Textview where the user composes their note.
@property (nonatomic, strong) IBOutlet UITextView *noteTextView;

/// Bottom space constraint for the text view.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomSpace;

/// Save button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *saveButton;

/**
 The parse object for which the note is being created.
 @note Only used for new notes.
 */
@property (nonatomic, strong) PFObject *entity;

/**
 The note object being edited.
 @note Only used for editing existing notes.
 */
@property (nonatomic, strong) MyNotes *savedNote;

/**
 Initializes the controller for the given entity and note.
 @param entity The PFObject that the note is for.
 @param note Nullable note. Queries for note if nil.
 */
- (id)initForEntity:(PFObject *)entity withNote:(MyNotes *)note;

@end

NS_ASSUME_NONNULL_END
