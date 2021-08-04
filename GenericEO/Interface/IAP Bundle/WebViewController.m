////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       WebViewController.m
/// @author     Lynette Sesodia
/// @date       1/23/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "WebViewController.h"
#import <WebKit/WebKit.h>

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

@interface WebViewController () <WKNavigationDelegate>

#pragma mark - Interface Builder

/// Header bar for the controller.
@property (nonatomic, strong) IBOutlet UIView *headerBar;

/// Label displaying the title of the controller in the header bar.
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;

/// Back button.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Main webview showing FAQs from website.
@property (nonatomic, strong) IBOutlet WKWebView *webView;

/// Loading indicator for the webview.
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIndicator;

/// The header bar title string.
@property (nonatomic, strong) NSString *titleStr;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureHeaderBar];
    [self setTitleText:self.title];
    
    self.loadingIndicator.hidesWhenStopped = YES;
    [self loadWebpageAtURL:self.websiteURL];
}

- (void)configureHeaderBar {
    // Create the header label
    self.headerLabel.font = [UIFont fontWithName:@"SFProText-Medium" size:28];
    
    // Set the background color
    self.headerBar.backgroundColor = [UIColor blackColor];
}

- (void)setTitleText:(NSString *)title {
    self.titleStr = title;
    if (title != nil) {
        NSAttributedString *aStr = [[NSAttributedString alloc] initWithString:title
                                                                   attributes:@{NSKernAttributeName : @(-1.5)}];
        self.headerLabel.attributedText = aStr;
    }
}

- (void)loadWebpageAtURL:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:self.websiteURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:request];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.loadingIndicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.loadingIndicator stopAnimating];
}


@end
