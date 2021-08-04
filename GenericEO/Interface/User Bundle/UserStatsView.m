////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UserStatsView.m
/// @author     Lynette Sesodia
/// @date       9/18/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "UserStatsView.h"
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

@interface UserStatsView()

/// Label displaying the number of reviews the user has created.
@property (nonatomic, strong) IBOutlet UILabel *numReviewsLabel;

/// Label displaying the caption for number of reviews.
@property (nonatomic, strong) IBOutlet UILabel *numReviewsCaptionLabel;

/// Label displaying the number of votes the user has created.
@property (nonatomic, strong) IBOutlet UILabel *numVotesLabel;

/// Label displaying the caption for number of votes.
@property (nonatomic, strong) IBOutlet UILabel *numVotesCaptionLabel;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation UserStatsView

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initForUser:(User *)user withNumberOfReviews:(NSInteger)reviewCount {
    self = [super init];
    if (self) {
        self.numReviewsLabel.text = [NSString stringWithFormat:@"%lu", reviewCount];
        self.numVotesLabel.text = [NSString stringWithFormat:@"%lu", user.votingRecord.count];
    }
    return self;
}

- (void)commonInit {
    [self loadNib];
    
    self.numReviewsLabel.font = [UIFont font:[UIFont boldTextFont] ofSize:16.0];
    self.numReviewsCaptionLabel.font = [UIFont font:[UIFont textFont] ofSize:13.0];
    self.numReviewsCaptionLabel.text = NSLocalizedString(@"Reviews", nil);
    
    self.numVotesLabel.font = [UIFont boldTextFont];
    self.numVotesCaptionLabel.font = [UIFont font:[UIFont textFont] ofSize:14.0];
    self.numVotesCaptionLabel.text = NSLocalizedString(@"Votes", nil);
}

- (void)loadNib {
    //Get nib from file
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserStatsView" owner:self options:nil] firstObject];
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self layoutIfNeeded];
}

#pragma mark - Actions

- (void)setUser:(User *)user {
    self.numVotesLabel.text = [NSString stringWithFormat:@"%lu", user.votingRecord.count];
}

- (void)setReviewCount:(NSInteger)numReviews {
    self.numReviewsLabel.text = [NSString stringWithFormat:@"%lu", numReviews];
    
}

@end
