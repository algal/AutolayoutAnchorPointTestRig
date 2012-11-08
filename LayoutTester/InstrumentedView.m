//
//  InstrumentedView.m
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-08.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InstrumentedView.h"

void AddBorderToLayerOfView(UIView * view) {
  CALayer * layer = view.layer;
  layer.borderColor = [[UIColor blueColor] CGColor];
  layer.borderWidth = 2.0f;
}

/**
 @param point bullseye of crosshairs, in view's coordinates
 @return the sublayer with the crosshairs image
 */
CALayer * AddCrossHairsSublayerToView(UIView * view, CGPoint point) {
  UIColor * const color = [UIColor redColor];
  CGFloat const crossHairDimension = 7.0f;
  
  CALayer * layer = view.layer;
  
  // draw a cross-hairs centered on the anchorpoint
  CGSize layerSize = layer.bounds.size;
  CGPoint thePoint = point;
  
  UIGraphicsBeginImageContextWithOptions(layerSize, NO, 0);
  CGContextRef c = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(c, [color CGColor]);
  
  CGContextMoveToPoint(c, thePoint.x - (crossHairDimension/2.0f), thePoint.y);
  CGContextAddLineToPoint(c, thePoint.x + (crossHairDimension/2.0f), thePoint.y);
  CGContextStrokePath(c);
  CGContextMoveToPoint(c,    thePoint.x,  thePoint.y - (crossHairDimension/2.0f));
  CGContextAddLineToPoint(c, thePoint.x , thePoint.y + (crossHairDimension/2.0f));
  CGContextStrokePath(c);
  
  UIImage * overlayImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // add crosshairs image to a sublayer
  CALayer * spotLayer = [CALayer layer];
  spotLayer.frame = layer.bounds;
  spotLayer.contents = (id)[overlayImage CGImage];
  [layer addSublayer:spotLayer];
  return spotLayer;
}

CALayer * AddCrosshairsSublayerToAnchorPointOfView(UIView * view) {
  CALayer * layer = view.layer;
  CGSize layerSize = layer.bounds.size;
  CGPoint anchorPointInLayerCoords = CGPointMake(layer.anchorPoint.x * layerSize.width,
                                                 layer.anchorPoint.y * layerSize.height);

  CGPoint anchorPointInViewCoords = anchorPointInLayerCoords;
  return AddCrossHairsSublayerToView(view, anchorPointInViewCoords);
}

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

-(void)showBorder
{
  AddBorderToLayerOfView(self);
}

-(void)addCrossHairsToAnchorPoint
{
  AddCrosshairsSublayerToAnchorPointOfView(self);
}

-(void)addCrossHairs:(CGPoint)point
{
  AddCrossHairsSublayerToView(self, point);
}
@end
