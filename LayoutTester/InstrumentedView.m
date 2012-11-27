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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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
