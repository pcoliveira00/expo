/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI12_0_0RCTModalHostViewManager.h"

#import "ABI12_0_0RCTBridge.h"
#import "ABI12_0_0RCTModalHostView.h"
#import "ABI12_0_0RCTModalHostViewController.h"
#import "ABI12_0_0RCTTouchHandler.h"
#import "ABI12_0_0RCTShadowView.h"
#import "ABI12_0_0RCTUtils.h"

@interface ABI12_0_0RCTModalHostShadowView : ABI12_0_0RCTShadowView

@end

@implementation ABI12_0_0RCTModalHostShadowView

- (void)insertReactABI12_0_0Subview:(id<ABI12_0_0RCTComponent>)subview atIndex:(NSInteger)atIndex
{
  [super insertReactABI12_0_0Subview:subview atIndex:atIndex];
  if ([subview isKindOfClass:[ABI12_0_0RCTShadowView class]]) {
    CGRect frame = {.origin = CGPointZero, .size = ABI12_0_0RCTScreenSize()};
    [(ABI12_0_0RCTShadowView *)subview setFrame:frame];
  }
}

@end

@interface ABI12_0_0RCTModalHostViewManager () <ABI12_0_0RCTModalHostViewInteractor>

@end

@implementation ABI12_0_0RCTModalHostViewManager
{
  NSHashTable *_hostViews;
}

ABI12_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI12_0_0RCTModalHostView *view = [[ABI12_0_0RCTModalHostView alloc] initWithBridge:self.bridge];
  view.delegate = self;
  if (!_hostViews) {
    _hostViews = [NSHashTable weakObjectsHashTable];
  }
  [_hostViews addObject:view];
  return view;
}

- (void)presentModalHostView:(ABI12_0_0RCTModalHostView *)modalHostView withViewController:(ABI12_0_0RCTModalHostViewController *)viewController animated:(BOOL)animated
{
  dispatch_block_t completionBlock = ^{
    if (modalHostView.onShow) {
      modalHostView.onShow(nil);
    }
  };
  if (_presentationBlock) {
    _presentationBlock([modalHostView ReactABI12_0_0ViewController], viewController, animated, completionBlock);
  } else {
    [[modalHostView ReactABI12_0_0ViewController] presentViewController:viewController animated:animated completion:completionBlock];
  }
}

- (void)dismissModalHostView:(ABI12_0_0RCTModalHostView *)modalHostView withViewController:(ABI12_0_0RCTModalHostViewController *)viewController animated:(BOOL)animated
{
  if (_dismissalBlock) {
    _dismissalBlock([modalHostView ReactABI12_0_0ViewController], viewController, animated, nil);
  } else {
    [viewController dismissViewControllerAnimated:animated completion:nil];
  }
}


- (ABI12_0_0RCTShadowView *)shadowView
{
  return [ABI12_0_0RCTModalHostShadowView new];
}

- (void)invalidate
{
  for (ABI12_0_0RCTModalHostView *hostView in _hostViews) {
    [hostView invalidate];
  }
  [_hostViews removeAllObjects];
}

ABI12_0_0RCT_EXPORT_VIEW_PROPERTY(animationType, NSString)
ABI12_0_0RCT_EXPORT_VIEW_PROPERTY(transparent, BOOL)
ABI12_0_0RCT_EXPORT_VIEW_PROPERTY(onShow, ABI12_0_0RCTDirectEventBlock)
ABI12_0_0RCT_EXPORT_VIEW_PROPERTY(supportedOrientations, NSArray)
ABI12_0_0RCT_EXPORT_VIEW_PROPERTY(onOrientationChange, ABI12_0_0RCTDirectEventBlock)

@end