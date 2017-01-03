//
//  DismissAnimator.m
//  NiceDismissTransition
//
//  Created by David Miotti on 03/01/2017.
//  Copyright © 2017 David Miotti. All rights reserved.
//

#import "DismissAnimator.h"
#import <Masonry/Masonry.h>

@implementation DismissAnimator

- (CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    UIView *dimingView = [UIView new];
    dimingView.backgroundColor = [UIColor blackColor];
    dimingView.alpha = 0.7f;

    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView insertSubview:dimingView belowSubview:fromVC.view];

    [dimingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(toVC.view);
    }];

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGPoint btmLeftCorner = CGPointMake(0, screenBounds.size.height);
    CGRect finalFrame = CGRectMake(btmLeftCorner.x, btmLeftCorner.y, screenBounds.size.width, screenBounds.size.height);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = finalFrame;
        fromVC.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        dimingView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [dimingView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
