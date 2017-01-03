//
//  DetailViewController.m
//  NiceDismissTransition
//
//  Created by David Miotti on 03/01/2017.
//  Copyright © 2017 David Miotti. All rights reserved.
//

#import "DetailViewController.h"
#import <Masonry/Masonry.h>

@interface DetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerScrollView;
@property (nonatomic, strong) UILabel *textContentLbl;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *dismissBbi = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(tappedDismissBtn:)];
    [self.navigationItem setLeftBarButtonItem:dismissBbi];

    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];

    self.containerScrollView = [[UIView alloc] init];
    [self.scrollView addSubview:self.containerScrollView];

    self.textContentLbl = [[UILabel alloc] init];
    self.textContentLbl.numberOfLines = 0;
    [self.containerScrollView addSubview:self.textContentLbl];

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
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
