//
//  LayoutUtils.m
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-09.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LayoutUtils.h"

/**
  Sets the anchorPoint of view, without moving it.
 
 This no longer works in the presence of autolayout.
 */
void SetViewAnchorPointMotionlessly(UIView * view, CGPoint anchorPoint )
{
  CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
  CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
  
  newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
  oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
  
  CGPoint position = view.layer.position;
  
  position.x -= oldPoint.x;
  position.x += newPoint.x;
  
  position.y -= oldPoint.y;
  position.y += newPoint.y;
  
  view.layer.position = position;
  view.layer.anchorPoint = anchorPoint;
}

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

CGPoint AnchorPointInSuperViewCoords(UIView *view)
{
  CALayer * layer = view.layer;
  CGPoint anchorPointInOwnCoords = CGPointMake(layer.anchorPoint.x * layer.bounds.size.width,
                                               layer.anchorPoint.y * layer.bounds.size.height);
  CGPoint anchorPointInParentCoords = [view convertPoint:anchorPointInOwnCoords
                                                  toView:view.superview];
  return anchorPointInParentCoords;
}
