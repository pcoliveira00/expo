/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */
#import "ABI27_0_0RNSVGRadialGradient.h"

@implementation ABI27_0_0RNSVGRadialGradient

- (void)setGradient:(NSArray<NSNumber *> *)gradient
{
    if (gradient == _gradient) {
        return;
    }
    
    _gradient = gradient;
    [self invalidate];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return nil;
}

- (void)parseReference
{
    NSArray<NSString *> *points = @[self.fx, self.fy, self.rx, self.ry, self.cx, self.cy];
    ABI27_0_0RNSVGPainter *painter = [[ABI27_0_0RNSVGPainter alloc] initWithPointsArray:points];
    [painter setUnits:self.gradientUnits];
    [painter setTransform:self.gradientTransform];
    [painter setRadialGradientColors:self.gradient];
    
    ABI27_0_0RNSVGSvgView *svg = [self getSvgView];
    if (self.gradientUnits == kRNSVGUnitsUserSpaceOnUse) {
        [painter setUserSpaceBoundingBox:[svg getContextBounds]];
    }
    
    [svg definePainter:painter painterName:self.name];
}

@end

