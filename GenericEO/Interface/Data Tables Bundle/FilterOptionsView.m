////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FilterOptionsView.m
/// @author     Lynette Sesodia
/// @date       6/18/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "FilterOptionsView.h"

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

static CGFloat const maxHeight = 500.0;
static CGFloat const minHeight = 44.0;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface FilterOptionsView()

/// The options type for the view.
@property (nonatomic) EODataType optionsType;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation FilterOptionsView

#pragma mark - Lifecycle

- (instancetype)initWithOptionsForType:(EODataType)type {
    self = [super init];
    if (self) {
        _optionsType = type;
        _state = VisualStateCollapsed;
        NSLog(@"state = %lu", self.state);
        
        //Get nib from file
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"FilterOptionsView" owner:self options:nil] firstObject];
        [self addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        [self layoutIfNeeded];
        
        self.layer.cornerRadius = 12.0;
        self.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

#pragma mark - UI

- (IBAction)collapseExpandView:(UIButton *)sender {
    NSLog(@"state = %lu", self.state);
    
    CGFloat duration = [self durationForChange:maxHeight-minHeight];
    
    switch (self.state) {
        case VisualStateCollapsed: {
            [self.delegate updateHeight:maxHeight
                   forFilterOptionsView:self
                      animationDuration:duration
                         withCompletion:^{
                             self.state = VisualStateExpanded;
                         }];
             [self rotateExpandCollapseButtonForState:VisualStateExpanded withDuration:duration];
        } break;
            
        case VisualStateInTransition:
            // Do nothing.
            break;
            
        case VisualStateExpanded: {
            [self.delegate updateHeight:minHeight
                   forFilterOptionsView:self
                      animationDuration:duration
                         withCompletion:^{
                             self.state = VisualStateCollapsed;
                         }];
            [self rotateExpandCollapseButtonForState:VisualStateCollapsed withDuration:duration];
        } break;
    }
}

- (void)rotateExpandCollapseButtonForState:(VisualState)state withDuration:(CGFloat)duration {
    double radians = (state == VisualStateExpanded) ? M_PI : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.expandCollapseBtn.transform = CGAffineTransformMakeRotation(radians);
    }];
}

#pragma mark - UIGestureRecognizers

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    // Get gesture information
    UIViewController *parent = (UIViewController *)self.delegate;
    CGPoint location = [recognizer locationInView:parent.view];
    
    // Calculate new height for view
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewHeight = screenHeight - location.y;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged: {
            // Display user touches exactly
            [self.delegate updateHeight:viewHeight
                   forFilterOptionsView:self
                      animationDuration:0.0
                         withCompletion:^{
                             self.state = VisualStateInTransition;
                         }];
        } break;
            
        case UIGestureRecognizerStateEnded: {
            CGPoint translation = [recognizer translationInView:parent.view];
            CGFloat duration = 0.0;
            
            // Snap to expanded or collapsed state
            if (viewHeight <= minHeight) {
                duration = [self durationForChange:minHeight-viewHeight];
                [self.delegate updateHeight:minHeight
                       forFilterOptionsView:self
                          animationDuration:duration
                             withCompletion:^{
                                 self.state = VisualStateCollapsed;
                             }];
                [self rotateExpandCollapseButtonForState:VisualStateCollapsed withDuration:duration];
            } else if (viewHeight >= maxHeight) {
                duration = [self durationForChange:maxHeight-viewHeight];
                [self.delegate updateHeight:maxHeight
                       forFilterOptionsView:self
                          animationDuration:duration
                             withCompletion:^{
                                 self.state = VisualStateExpanded;
                          }];
                [self rotateExpandCollapseButtonForState:VisualStateExpanded withDuration:duration];
            } else {
                if (translation.y > 0) {
                    duration = [self durationForChange:screenHeight-minHeight-location.y];
                    [self.delegate updateHeight:minHeight
                           forFilterOptionsView:self
                              animationDuration:duration
                                 withCompletion:^{
                                     self.state = VisualStateCollapsed;
                                 }];
                    [self rotateExpandCollapseButtonForState:VisualStateCollapsed withDuration:duration];
                } else {
                    duration = [self durationForChange:screenHeight-maxHeight-location.y];
                    [self.delegate updateHeight:maxHeight
                           forFilterOptionsView:self
                              animationDuration:duration
                                 withCompletion:^{
                                     self.state = VisualStateExpanded;
                                 }];
                    [self rotateExpandCollapseButtonForState:VisualStateExpanded withDuration:duration];
                }
            }
        } break;
            
        default:
            break;
    }
}

#pragma mark - Calculations

- (CGFloat)durationForChange:(double)delta {
    CGFloat duration = 0.2;
    for (double i=0.0; i<fabs(delta); i+=150.0) {
        duration += 0.1;
    }
    return duration;
}


@end
