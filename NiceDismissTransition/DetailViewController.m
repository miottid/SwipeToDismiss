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

@interface DetailViewController ()<UIViewControllerTransitioningDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UIButton *dimissBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerScrollView;
@property (nonatomic, strong) UILabel *textContentLbl;

@property (nonatomic, strong) DismissInteractor *dimissInteractor;

@end

@implementation DetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dimissInteractor = [DismissInteractor new];
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
    [self.view addSubview:self.navBarView];

    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
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

- (void)prepareContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lorem_ipsum" ofType:@"txt"];
    NSError *textError = nil;
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&textError];
    if (textError) {
        NSLog(@"Error while opening lorem ipsum file: %@", textError);
    }
    self.textContentLbl.text = text;
}

#pragma mark - Configure Layout

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"contentOffset: %f", scrollView.contentOffset.y);

//    let percentThreshold:CGFloat = 0.3
//
//    // convert y-position to downward pull progress (percentage)
//    let translation = sender.translationInView(view)
//    let verticalMovement = translation.y / view.bounds.height
//    let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
//    let downwardMovementPercent = fminf(downwardMovement, 1.0)
//    let progress = CGFloat(downwardMovementPercent)
}

@end
