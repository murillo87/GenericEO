////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABAddNoteViewController.m
/// @author     Lynette Sesodia
/// @date       7/29/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABAddNoteViewController.h"

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

@interface ABAddNoteViewController ()

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABAddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.font = [UIFont headerFont];
    
    if (self.savedNote != nil) {
        self.titleLabel.text = NSLocalizedString(@"Edit Note", nil);
    } else {
        self.titleLabel.text = NSLocalizedString(@"Add Note", nil);
    }
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    self.saveButton.tintColor = [UIColor targetAccentColor];
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
