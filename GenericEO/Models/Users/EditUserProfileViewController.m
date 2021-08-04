////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       EditUserProfileViewController.m
/// @author     Lynette Sesodia
/// @date       2/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "EditUserProfileViewController.h"
#import "ProfileFieldTableViewCell.h"
#import "UserManager.h"
#import "EditFieldViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UserStatsView.h"
#import "ReviewManager.h"
#import "MBProgressHUD.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kFieldCell @"ProfileFieldTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface EditUserProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Button displaying the users profile image. Tap to edit.
@property (nonatomic, strong) IBOutlet UIButton *profileImageButton;

/// Caption label for profile image button.
@property (nonatomic, strong) IBOutlet UILabel *profileImageCaptionLabel;

/// Top edit button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *editButton;

/// Tableview displaying user profile information.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// The current user to display the profile for.
@property (nonatomic, strong) User *currentUser;

/// The profile pic for the current user.
@property (nonatomic, strong) UIImage *currentUserProfileImage;

/// Reference to user manager.
@property (nonatomic, strong) UserManager *userManager;

/// Progress indicator for the view.
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation EditUserProfileViewController

- (id)initForUser:(User *)user withProfileImage:(UIImage *)profilePic {
    self = [super init];
    if (self) {
        self.currentUser = user;
        self.currentUserProfileImage = profilePic;
        
        self.userManager = [[UserManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    
    self.profileImageCaptionLabel.text = NSLocalizedString(@"Change Profile Image", nil);
    self.profileImageCaptionLabel.font = [UIFont textFont];
    self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height/2.;
    self.profileImageButton.layer.masksToBounds = YES;
    [self.profileImageButton setImage:self.currentUserProfileImage forState:UIControlStateNormal];
    
    [self.tableView registerNib:[UINib nibWithNibName:kFieldCell bundle:nil] forCellReuseIdentifier:kFieldCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (user != nil) {
            self.currentUser = user;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateProfileImage:(id)sender {
    
    NSString *title = NSLocalizedString(@"Change Profile Photo", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        //
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = true;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:imgPicker animated:YES completion:^{}];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Choose From Library", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        //
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = true;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:imgPicker animated:YES completion:^{}];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Remove Profile Photo", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self.userManager deleteProfileImageWithCompletion:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [self.profileImageButton setImage:[UIImage imageNamed:@"icon-user"] forState:UIControlStateNormal];
                }
            });
        }];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    [alertController show];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    // Upload chosen image
    __block UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.userManager updateProfileImage:chosenImage withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            // Display error
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.profileImageButton setImage:chosenImage forState:UIControlStateNormal];
                self.currentUserProfileImage = chosenImage;
            });
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditFieldViewController *vc = nil;
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: // Username
                    //vc = [[EditFieldViewController alloc] initForType:DataTypeUsername withValue:self.currentUser.username];
                    break;
                    
                case 1:
                    vc = [[EditFieldViewController alloc] initForType:DataTypeEmail withValue:self.currentUser.email];
                    break;
                    
                case 2:
                    vc = [[EditFieldViewController alloc] initForType:DataTypePassword];
                    break;
                    
                default:
                    break;
            }
        } break;
            
        case 1: {
            // Logout
            UserManager *manager = [[UserManager alloc] init];
            [manager logoutUserWithCompletion:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:^{}];
                    });
                }
            }];
        } break;
            
        default:
            break;
    }
    
    if (vc != nil) {
        [self.navigationController showViewController:vc sender:self];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
            
        case 1:
            return 1;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 60.0;
            break;
            
        default:
            return 44.;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFieldCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.valueLabel.textColor = [UIColor targetAccentColor];
    
    switch (indexPath.section) {
        case 0: {
           switch (indexPath.row) {
                case 0: { // Username
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.titleLabel.text = NSLocalizedString(@"Username (Public)", nil);
                    
                    if (self.currentUser != nil) {
                        cell.valueLabel.text = self.currentUser.username;
                    } else {
                        cell.valueLabel.text = @"";
                    }
                } break;
                    
                case 1: { // Email
                    cell.titleLabel.text = NSLocalizedString(@"Email (Private)", nil);
                    
                    if (self.currentUser != nil) {
                        cell.valueLabel.text = self.currentUser.email;
                    } else {
                        cell.valueLabel.text = @"";
                    }
                } break;
                    
                case 2: { // Password
                    cell.titleLabel.text = NSLocalizedString(@"Password", nil);
                    
                    if (self.currentUser != nil) {
                        cell.valueLabel.text = @"*******";
                    } else {
                        cell.valueLabel.text = @"";
                    }
                } break;
                    
                    
                default:
                    break;
            }
        } break;
            
        case 1: { // Logout
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = NSLocalizedString(@"Logout", nil);
            cell.textLabel.textColor = [UIColor systemRedColor];
            return cell;
        } break;
                       
       default:
           break;
    }
    
    return cell;
}

@end
