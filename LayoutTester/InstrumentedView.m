//
//  InstrumentedView.m
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-08.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InstrumentedView.h"

#import "LayoutUtils.h"

@implementation InstrumentedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)strokeBounds
{
  AddBorderToLayerOfView(self);
}

-(CALayer*)addCrossHairsToAnchorPoint
{
  return AddCrosshairsSublayerToAnchorPointOfView(self);
}

#ifdef USING_AUTOLAYOUT
+(BOOL)requiresConstraintBasedLayout { return YES; }
#endif
@end
