////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       AddNoteViewController.m
/// @author     Lynette Sesodia
/// @date       7/29/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "AddNoteViewController.h"
#import "ABAddNoteViewController.h"
#import "ESTLAddNoteViewController.h"

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

@interface AddNoteViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation AddNoteViewController

- (id)initForEntity:(PFObject *)entity withNote:(MyNotes *)note {
#ifdef AB
    self = [[ABAddNoteViewController alloc] init];
#else
    self = [[ESTLAddNoteViewController alloc] init];
#endif
    
    self.entity = entity;
    self.savedNote = note;
    
    // If the passed in note is nil, check Core Data
    if (!self.savedNote) {
        NSString *identifier = entity[@"uuid"];
        self.savedNote = [[CoreDataManager sharedManager] getNoteForID:identifier];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.noteTextView.delegate = self;
    
    // Display saved note, if available
    if (self.savedNote) {
        self.noteTextView.text = self.savedNote.text;
        self.noteTextView.textColor = [UIColor darkGrayColor];
    }
    
    // Listen for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDid:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDid:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - IBAction

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(UIButton *)sender {
    // Prevent saving of default note
    if ([self.noteTextView.text isEqualToString:DefaultNote]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // Save the note
    if (self.savedNote) {
        [[CoreDataManager sharedManager] updateNote:self.savedNote withText:self.noteTextView.text completion:^(BOOL didUpdate, NSError *error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [[CoreDataManager sharedManager] saveNoteWithText:self.noteTextView.text forObject:self.entity withCompetion:^(BOOL didSave, NSError *error) {
            [self.navigationController popViewControllerAnimated:YES];
            
            IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsAddedNote];
            [event setValue:[NSString stringWithFormat:@"%@", self.entity[@"name"]]
               forAttribute:AnalyticsNameAttribute];
            [[IPAAnalyticsManager sharedInstance] reportEvent:event];
        }];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:DefaultNote]) {
        [textView setText:@""];
        textView.textColor = [UIColor darkGrayColor];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:DefaultNote]) {
        [textView setText:@""];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [textView setText:DefaultNote];
        textView.textColor = [UIColor lightGrayColor];
    } else {
        textView.textColor = [UIColor darkGrayColor];
    }
}

#pragma mark - Keyboard

- (void)keyboardDid:(NSNotification *)notification {
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self setTextViewBottomConstraint:height];
}

- (void)setTextViewBottomConstraint:(CGFloat)space {
    [self.view layoutIfNeeded];
    
    self.bottomSpace.constant = space + AddNoteBottomMargin;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
