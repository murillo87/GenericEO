////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ReviewTableViewCell.m
/// @author     Lynette Sesodia
/// @date       2/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ReviewTableViewCell.h"
#import "UserManager.h"
#import "NetworkManager.h"
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

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ReviewTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.reviewTextLabel.font = [UIFont textFont];
    self.authorIconImageView.image = [UIImage imageNamed:@"icon-user"];
    self.authorIconImageView.layer.cornerRadius = self.authorIconImageView.frame.size.height/2;
    self.authorIconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

- (void)configureCellForReview:(Review *)review {
    self.review = review;
    
    self.reviewTextLabel.text = review.text;
    self.starRatingImageView.image = [self imageForStarRating:review.starValue];
    self.voteCountLabel.text = [self voteCountForReview:review];
    self.authorUsernameLabel.text = review.authorUsername;
    
    self.upvoteButton.tintColor = [UIColor systemGray4Color];
    self.downvoteButton.tintColor = [UIColor systemGray4Color];
    
    UserManager *manager = [[UserManager alloc] init];
    [manager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (user) {
            // Determine if the current user voting record includes the review
            if ([user.votingRecord.allKeys containsObject:review.uuid]) {
                NSInteger value = [[user.votingRecord valueForKey:review.uuid] integerValue];
                if (value == 1) {
                    self.upvoteButton.tintColor = [UIColor targetAccentColor];
                } else if (value == -1) {
                    self.downvoteButton.tintColor = [UIColor targetAccentColor];
                }
            }
            
            // Display the profile image
            NSURLRequest *request = [NSURLRequest requestWithURL:[manager getProfileImageURLForUserUUID:review.authorID]
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                 timeoutInterval:30.0];
            
            __weak UIImageView *weakImage = self.authorIconImageView;
            [weakImage setImageWithURLRequest:request
                                      placeholderImage:[UIImage imageNamed:@"icon-user"]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakImage.image = image;
                [weakImage setNeedsLayout];
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {}];
        }
    }];
}

- (void)configureCellForUser:(User *)user review:(Review *)review {

    self.review = review;
    
    self.reviewTextLabel.text = review.text;
    self.starRatingImageView.image = [self imageForStarRating:review.starValue];
    self.voteCountLabel.text = [self voteCountForReview:review];
    
    self.upvoteButton.tintColor = [UIColor systemGray4Color];
    self.downvoteButton.tintColor = [UIColor systemGray4Color];
    
    if (user) {
        // Determine if the current user voting record includes the review
        if ([user.votingRecord.allKeys containsObject:review.uuid]) {
            NSInteger value = [[user.votingRecord valueForKey:review.uuid] integerValue];
            if (value == 1) {
                self.upvoteButton.tintColor = [UIColor targetAccentColor];
            } else if (value == -1) {
                self.downvoteButton.tintColor = [UIColor targetAccentColor];
            }
        }
    }
    
    // Determine if the review is for an oil or recipe
    if ([review.parentID containsString:[NSString stringWithFormat:@"%@-10-", UUIDPrefix]]) { // Oil Type
        
            /// Get the oil name from UUID
            [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                     withValues:@[review.parentID]
                                                 withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                if (objects != nil && objects.count > 0) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
        #ifdef DOTERRA
                        PFDoterraOil *oil = (PFDoterraOil *)[objects firstObject];
                        self.authorUsernameLabel.text = oil.name;
                        self.authorIconImageView.backgroundColor = [UIColor colorWithHexString:oil.color];
                        if ([oil.type containsString:@"RollOn"]) {
                            self.authorIconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
                        } else {
                            self.authorIconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
                        }
        #elif YOUNGLIVING
                        PFYoungLivingOil *oil = (PFYoungLivingOil *)[objects firstObject];
                        self.authorUsernameLabel.text = oil.name;
                        self.authorIconImageView.backgroundColor = [UIColor colorWithHexString:oil.color];
                        if ([oil.type isEqualToString:@"Oil-Light"]) {
                            self.authorIconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
                        } else if ([oil.type isEqualToString:@"Roll-On"]) {
                            self.authorIconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
                        } else {
                            self.authorIconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
                        }
        #else
                        PFObject *object = [objects firstObject];
                        self.authorUsernameLabel.text = object[@"name"];
        #endif
                    });
                }
            }];
        
    } else if ([review.parentID containsString:[NSString stringWithFormat:@"%@-02-", UUIDPrefix]]) {
        
        [[NetworkManager sharedManager] queryRecipesWithUUIDs:@[review.parentID]
                                               withCompletion:^(NSArray<PFRecipe *> * _Nonnull recipes, NSError * _Nonnull error) {
            if (recipes != nil && recipes.count > 0) {
                
                PFRecipe *recipe = [recipes firstObject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.authorUsernameLabel.text = recipe.name.capitalizedString;
                    self.authorIconImageView.image = [UIImage imageNamed:@"tbi-recipe"];
                });
            }
        }];
    }
}

- (NSString *)voteCountForReview:(Review *)review {
    int count = 0;
    count += [review.upCount intValue];
    count -= [review.downCount intValue];
    
    // Number formatting not to exceed 6 characters
    if (count >= 1000000) {
        // Format millions to #.#M
        double decimal = (double)count / 1000000.0;
        return [NSString stringWithFormat:@"%.1fM", decimal];
    } else if (count >= 1000) {
        double decimal = (double)count / 1000.0;
        return [NSString stringWithFormat:@"%.1fK", decimal];
    }
    
    return [NSString stringWithFormat:@"%d", count];
}

- (UIImage *)imageForStarRating:(NSNumber *)rating {
    int stars = [rating intValue];
    
    if      (stars == 5) return [UIImage imageNamed:@"5.0-stars"];
    else if (stars == 4) return [UIImage imageNamed:@"4.0-stars"];
    else if (stars == 3) return [UIImage imageNamed:@"3.0-stars"];
    else if (stars == 2) return [UIImage imageNamed:@"2.0-stars"];
    else if (stars == 1) return [UIImage imageNamed:@"1.0-stars"];
    else                 return [UIImage imageNamed:@"0.0-stars"];
}

#pragma mark - Actions

- (IBAction)upVote:(UIButton *)sender {
    [self.delegate shouldUpvoteReviewForCell:self];
}

- (IBAction)downVote:(UIButton *)sender {
    [self.delegate shouldDownvoteReviewForCell:self];
}

@end
