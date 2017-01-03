//
//  DismissInteractor.h
//  NiceDismissTransition
//
//  Created by David Miotti on 03/01/2017.
//  Copyright © 2017 David Miotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DismissInteractor : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL hasStarted;
@property (nonatomic, assign) BOOL shouldFinish;

@end
