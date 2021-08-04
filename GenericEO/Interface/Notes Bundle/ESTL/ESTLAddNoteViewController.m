////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLAddNotesViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

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

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@interface ESTLAddNoteViewController () <UITextViewDelegate>

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// Main view containing noteTextView.
@property (nonatomic, strong) IBOutlet UIView *mainView;

@end

@implementation ESTLAddNoteViewController

- (id)initForEntity:(PFObject *)entity withNote:(MyNotes *)note {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Add a nav bar item for saving
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self
                                   action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
