//
//  ViewController.m
//  NiceDismissTransition
//
//  Created by David Miotti on 03/01/2017.
//  Copyright © 2017 David Miotti. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Open my modal" forState:UIControlStateNormal];
    UIColor *blueColor = [UIColor colorWithRed:0.f/255.f green:106.f/255.f blue:180.f/255.f alpha:1.f];
    [btn setTintColor:blueColor];
    [btn addTarget:self action:@selector(tappedOpenModal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.greaterThanOrEqualTo(@44.f);
        make.height.greaterThanOrEqualTo(@44.f);
    }];
}

- (void)tappedOpenModal:(id)sender {
    UIViewController *detailVC = [[DetailViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
