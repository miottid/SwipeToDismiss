//
//  DetailViewController.m
//  NiceDismissTransition
//
//  Created by David Miotti on 03/01/2017.
//  Copyright © 2017 David Miotti. All rights reserved.
//

#import "DetailViewController.h"
#import <Masonry/Masonry.h>
#import "DismissAnimator.h"
#import "DismissInteractor.h"

@interface DetailViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UIButton *dimissBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerScrollView;
@property (nonatomic, strong) UILabel *textContentLbl;

@property (nonatomic, strong) DismissInteractor *dismissInteractor;
@property (nonatomic, assign) CGFloat originalDismissStartingOffsetY;

@end

@implementation DetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dismissInteractor = [DismissInteractor new];
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    UIColor *blueColor = [UIColor colorWithRed:0.f/255.f green:106.f/255.f blue:180.f/255.f alpha:1.f];

    self.navBarView = [UIView new];
    self.navBarView.backgroundColor = blueColor;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFromHeaderBar:)];
    [self.navBarView addGestureRecognizer:pan];
    [self.view addSubview:self.navBarView];

    self.scrollView = [UIScrollView new];
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(handlePan:)];
    [self.view addSubview:self.scrollView];

    self.containerScrollView = [UIView new];
    [self.scrollView addSubview:self.containerScrollView];

    self.textContentLbl = [UILabel new];
    self.textContentLbl.numberOfLines = 0;
    [self.containerScrollView addSubview:self.textContentLbl];

    self.dimissBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.dimissBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dimissBtn setTintColor:[UIColor whiteColor]];
    [self.dimissBtn addTarget:self action:@selector(tappedDismissBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:self.dimissBtn];

    [self configureLayoutConstraints];
    [self prepareContent];
}

#pragma mark - Private methods

/// Display the text content
- (void)prepareContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lorem_ipsum" ofType:@"txt"];
    NSError *textError = nil;
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&textError];
    if (textError) {
        NSLog(@"Error while opening lorem ipsum file: %@", textError);
    }
    self.textContentLbl.text = text;
}

/// Configure Layout Constraints
- (void)configureLayoutConstraints {
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@64.f);
    }];
    [self.dimissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBarView).offset(15.f);
        make.centerY.equalTo(self.navBarView).offset(7.f);
        make.height.greaterThanOrEqualTo(@44.f);
        make.width.greaterThanOrEqualTo(@44.f);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.view);
    }];
    [self.textContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerScrollView);
    }];
}

#pragma mark - Dismiss button

- (void)tappedDismissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DismissAnimator new];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.dismissInteractor.hasStarted ? self.dismissInteractor : nil;
}

#pragma mark - UIPanGestureRecognizer target/action

// Handle interactive dismissing of controller from scrollView
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGFloat scrollViewOffsetY = self.scrollView.contentOffset.y;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.originalDismissStartingOffsetY = scrollViewOffsetY;
    }
    
    // converts the pan gesture coordinate to the app window’s coordinate space
    CGPoint translation = [recognizer translationInView:self.view.window];
    // converts the vertical distance to a percentage, based on the overall screen height
    CGFloat diff = translation.y - self.originalDismissStartingOffsetY;
    
    if (scrollViewOffsetY > 0 && !self.dismissInteractor.hasStarted) {
        /// Don't dismiss if we're just scrolling inside the scrollView
        return;
    }
    
    [self handlePan:diff forState:recognizer.state];
    
    self.scrollView.showsVerticalScrollIndicator = !self.dismissInteractor.hasStarted;
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

// Handle interactive dismissing of controller from navbar header
- (void)handlePanFromHeaderBar:(UIPanGestureRecognizer *)recognizer {
    // converts the pan gesture coordinate to the app window’s coordinate space
    CGPoint translation = [recognizer translationInView:self.view.window];
    [self handlePan:translation.y forState:recognizer.state];
}

- (void)handlePan:(CGFloat)translationY forState:(UIGestureRecognizerState)state {
    // how far down the user has to drag in order to trigger the modal dismissal
    CGFloat percentThreshold = 0.3f;
    // converts the vertical distance to a percentage, based on the overall screen height
    CGFloat verticalMovement = translationY / self.view.bounds.size.height;
    // captures movement in the downward direction. Upward movement is ignored
    CGFloat downwardMovement = fmaxf(verticalMovement, 0.f);
    // caps the percentage to a maximum of 100%
    CGFloat progress = fminf(downwardMovement, 1.f);
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            self.dismissInteractor.hasStarted = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case UIGestureRecognizerStateChanged:
            if (!self.dismissInteractor.hasStarted) {
                self.dismissInteractor.hasStarted = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            self.dismissInteractor.shouldFinish = progress > percentThreshold;
            [self.dismissInteractor updateInteractiveTransition:progress];
            
            if (progress <= 0.f) {
                self.dismissInteractor.hasStarted = NO;
                [self.dismissInteractor cancelInteractiveTransition];
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            self.dismissInteractor.hasStarted = NO;
            [self.dismissInteractor cancelInteractiveTransition];
            break;
            
        case UIGestureRecognizerStateEnded:
            self.dismissInteractor.hasStarted = NO;
            if (self.dismissInteractor.shouldFinish) {
                [self.dismissInteractor finishInteractiveTransition];
            } else {
                [self.dismissInteractor cancelInteractiveTransition];
            }
            break;
            
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
