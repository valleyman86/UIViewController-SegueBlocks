//
//  UIViewController+SequeBlocks.m
//  Kixyo
//
//  Created by Joseph Gentry on 12/11/15.
//  Copyright © 2015 kixyo. All rights reserved.
//

#import "UIViewController+SequeBlocks.h"
#import <objc/runtime.h>

@interface SegueBlockObject: NSObject

@property(nonatomic, copy) SegueBlock block;

@end

@implementation SegueBlockObject
@end

@implementation UIViewController (SegueBlocks)

static IMP __original_PrepareForSegue_Imp;
static const void *UIViewControllerSegueDefaultBlocks = &UIViewControllerSegueDefaultBlocks;


void _replacement_PrepareForSegue(id self, SEL _cmd, UIStoryboardSegue *segue, id sender)
{
    id newSender = sender; //We dont want to send our block object to the user. Keep it internal.
    
    if ([sender isKindOfClass:SegueBlockObject.class]) {
        SegueBlockObject *blockObject = sender;
        
        if (blockObject.block) {
            blockObject.block(segue.sourceViewController, segue.destinationViewController);
        }
        
        newSender = blockObject.block;
    } else {
        NSMutableDictionary<NSString *, SegueBlock> *blocks = objc_getAssociatedObject(self, UIViewControllerSegueDefaultBlocks);
        if (blocks[segue.identifier]) {
            blocks[segue.identifier](segue.sourceViewController, segue.destinationViewController);
        }
    }
    
    ((void(*)(id, SEL, UIStoryboardSegue *, id))__original_PrepareForSegue_Imp)(self, _cmd, segue, newSender);
}

- (void)performSegueWithIdentifier:(NSString *)identifier block:(SegueBlock)block
{
    [self swizzlePrepareForSegue];
    
    SegueBlockObject *blockObject = [[SegueBlockObject alloc] init];
    blockObject.block = block;
    
    [self performSegueWithIdentifier:identifier sender:blockObject];
}

- (void)setDefaultBlockForIdentifier:(NSString *)identifier  block:(SegueBlock)block
{
     [self swizzlePrepareForSegue];
    
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, UIViewControllerSegueDefaultBlocks);
    if (!blocks) {
        blocks = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIViewControllerSegueDefaultBlocks, blocks, OBJC_ASSOCIATION_RETAIN);
    }
    
    blocks[identifier] = block;
}

- (void)swizzlePrepareForSegue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method instanceMethod = class_getInstanceMethod([self class], @selector(prepareForSegue:sender:));
        __original_PrepareForSegue_Imp = method_setImplementation(instanceMethod, (IMP)_replacement_PrepareForSegue);
    });
}

@end
