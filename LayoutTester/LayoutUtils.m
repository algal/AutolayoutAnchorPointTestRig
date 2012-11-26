//
//  LayoutUtils.m
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-09.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LayoutUtils.h"


CGPoint GetAnchorPointInViewCoords(UIView *view)
{
  return CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                     view.bounds.size.height * view.layer.anchorPoint.y);
}

CGPoint GetAnchorPointInSuperViewCoords(UIView *view)
{
  CALayer * layer = view.layer;
  CGPoint anchorPointInOwnCoords = CGPointMake(layer.anchorPoint.x * layer.bounds.size.width,
                                               layer.anchorPoint.y * layer.bounds.size.height);
  CGPoint anchorPointInParentCoords = [view convertPoint:anchorPointInOwnCoords
                                                  toView:view.superview];
  return anchorPointInParentCoords;
}

/**
  Sets the anchorPoint of view, without moving it.
 
 @param anchorPoint point in view's own unit coords (i.e., x in [0,1])
 
 This no longer works in the presence of autolayout.
 */
void SetViewAnchorPointMotionlessly(UIView * view, CGPoint anchorPoint )
{
  // asset: old and new anchorPoint are in view's unit coords
  CGPoint const oldAnchorPoint = view.layer.anchorPoint;
  CGPoint const newAnchorPoint = anchorPoint;
  
  // transform old and new anchorPoints into view's absolute coords
  CGPoint newPoint = CGPointMake(view.bounds.size.width * newAnchorPoint.x, view.bounds.size.height * newAnchorPoint.y);
  CGPoint oldPoint = CGPointMake(view.bounds.size.width * oldAnchorPoint.x, view.bounds.size.height * oldAnchorPoint.y);
  
  // transorm old and new anchorPoint into superview's coords
  newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
  oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
  
  // get the old position (in superview coords)
  CGPoint const oldPosition = view.layer.position;

  // calculate a newPosition, from the delta in the anchorPoint
  CGPoint const newPosition = CGPointApplyAffineTransform(oldPosition,
                                                          CGAffineTransformMakeTranslation((newPoint.x - oldPoint.x),
                                                                                           (newPoint.y - oldPoint.y)));
  view.layer.position = newPosition;
  view.layer.anchorPoint = newAnchorPoint;
}

void AddBorderToLayerOfView(UIView * view) {
  CALayer * layer = view.layer;
  layer.borderColor = [[UIColor blueColor] CGColor];
  layer.borderWidth = 2.0f;
}

/**
  Adds a sublayer to view, drawing rect.
 */
CALayer * AddRectLayerToView(UIView * view, CGRect rect)
{
  UIColor * const color = [UIColor greenColor];

  CALayer * rectLayer = [[CALayer alloc] init];
//  rectLayer.backgroundColor = [[UIColor yellowColor] CGColor];
  rectLayer.frame = rect;
  rectLayer.borderWidth=1.0f;
  rectLayer.borderColor = [color CGColor];
  [view.layer addSublayer:rectLayer];
  [view.layer setNeedsDisplayInRect:rect];
  return rectLayer;
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

