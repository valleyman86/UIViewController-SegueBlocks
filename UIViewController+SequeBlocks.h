//
//  UIViewController+SequeBlocks.h
//  Kixyo
//
//  Created by Joseph Gentry on 12/11/15.
//  Copyright © 2015 kixyo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ SegueBlock)(id sourceViewController, id destinationViewController);

@interface UIViewController (SegueBlocks)

- (void)performSegueWithIdentifier:(NSString *)identifier block:(SegueBlock)block;
- (void)setDefaultBlockForIdentifier:(NSString *)identifier  block:(SegueBlock)block;

@end