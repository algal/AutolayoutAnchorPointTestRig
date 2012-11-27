//
//  LayoutUtils.m
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-09.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LayoutUtils.h"


NSString * NSStringFromBOOL(BOOL flag) {
  return (flag ? @"YES" : @"NO");
}

NSString * NSStringFromUIViewAutoResizing(UIViewAutoresizing autoResizingMask) {
  NSArray * const indexOfBitToResizingValue =@[@"UIViewAutoresizingFlexibleLeftMargin",
  @"UIViewAutoresizingFlexibleWidth",
  @"UIViewAutoresizingFlexibleRightMargin",
  @"UIViewAutoresizingFlexibleTopMargin",
  @"UIViewAutoresizingFlexibleHeight",
  @"UIViewAutoresizingFlexibleBottomMargin"];
  
  NSString * result = @"";
  if (autoResizingMask == 0) {
    result = @"[no-mask]";
  }
  else
  {
    result = @"[";
    for (int indexOfBit = 0; indexOfBit < [indexOfBitToResizingValue count]; ++indexOfBit) {
      int mask = 1 << indexOfBit;
      int masked_autoResizingMask = autoResizingMask & mask;
      int thebit = masked_autoResizingMask >> indexOfBit;
      
      if (thebit==1) {
        result = [result stringByAppendingString:indexOfBitToResizingValue[indexOfBit]];
        result = [result stringByAppendingString:@","];
      }
    }
    result = [result stringByAppendingString:@"]"];
  }
  return result;
}

void LogLayoutPropertiesOfUIView(UIView *view,NSString * viewName) {
  NSLog(@"%@=%@",viewName,view);
  NSLog(@"%@.translatesAutoresizingMaskIntoConstraints=%@",viewName,NSStringFromBOOL(view.translatesAutoresizingMaskIntoConstraints));
  NSLog(@"%@.autoresizingMask=%@",viewName,NSStringFromUIViewAutoResizing(view.autoresizingMask));
  NSLog(@"%@.constraints=%@",viewName,view.constraints);
  NSLog(@"%@.hasAmbiguousLayout=%@",viewName,NSStringFromBOOL(view.hasAmbiguousLayout));
  NSLog(@"%@.alignmentRectInsets=%@",viewName,NSStringFromUIEdgeInsets(view.alignmentRectInsets));
}

void LogPoint(CGPoint point, NSString * pointName) {
  NSLog(@"%@=%@",pointName,NSStringFromCGPoint(point));
}

CGPoint CGPointGetCenter(CGRect rect) {
  return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


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

void SetViewAnchorPointMotionlesslyIgnoringTransform(UIView * view, CGPoint anchorPoint )
{
  CGRect oldFrame = view.frame;
  view.layer.anchorPoint = anchorPoint;
  view.frame = oldFrame;
}

/**
  Sets the anchorPoint of view, without moving it.
 
 @param anchorPoint point in view's own unit coords (i.e., x in [0,1])
 
 This no longer works in the presence of autolayout.
 */
void SetViewAnchorPointMotionlessly(UIView * view, CGPoint anchorPoint )
{
  // assert: old and new anchorPoint are in view's unit coords
  CGPoint const oldAnchorPoint = view.layer.anchorPoint;
  CGPoint const newAnchorPoint = anchorPoint;
  
  // Calculate anchorPoints in view's absolute coords
  CGPoint oldPoint = CGPointMake(view.bounds.size.width * oldAnchorPoint.x,
                                 view.bounds.size.height * oldAnchorPoint.y);
  CGPoint newPoint = CGPointMake(view.bounds.size.width * newAnchorPoint.x,
                                 view.bounds.size.height * newAnchorPoint.y);
  
  // Calculate the transformed anchorPoints, so the vector between them
  // represents the displacement as seen from the superview
  oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
  newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
  
  // Calculate the delta between the anchorPoints
  CGPoint const delta = CGPointMake(newPoint.x-oldPoint.x, newPoint.y-oldPoint.y);
  
  // get the old position (in superview coords)
  CGPoint const oldPosition = view.layer.position;

  // calculate a newPosition, from the delta in the anchorPoint.
  // this newPosition will compensate for the effect of the change in anchorPoint
  CGPoint const newPosition = CGPointApplyAffineTransform(oldPosition,
                                                          CGAffineTransformMakeTranslation(delta.x,
                                                                                           delta.y));
  view.layer.position = newPosition;
  view.layer.anchorPoint = newAnchorPoint;
}

/**
  Set the anchorPoint of view without changing is perceived position.
 
 @param view view whose anchorPoint we will mutate
 @param anchorPoint new anchorPoint of the view in unit coords (e.g., {0.5,1.0})
 @param xConstraint an NSLayoutConstraint whose constant property adjust's view x.center
 @param yConstraint an NSLayoutConstraint whose constant property adjust's view y.center

 As multiple constraints can contribute to determining a view's center, the user of this
 function must specify which constraint they want modified in order to compensate for the
 modification in anchorPoint.
 
 TODO: make this work with transformed views as well. The problem is that trasnforms
 change view.frame, and layouts constraints effectively act on view.frame, so 
 we've got to update not only layout constraints that determine view.layer.position (equivalently,
 view.center) but also those layout constraints that determine width and height.
 
 */
void SetViewAnchorPointMotionlesslyUpdatingConstraints(UIView * view,CGPoint anchorPoint,
                                                       NSLayoutConstraint * xConstraint,
                                                       NSLayoutConstraint * yConstraint)
{
  // assert: old and new anchorPoint are in view's unit coords
  CGPoint const oldAnchorPoint = view.layer.anchorPoint;
  CGPoint const newAnchorPoint = anchorPoint;
  
  // Calculate anchorPoints in view's absolute coords
  CGPoint oldPoint = CGPointMake(view.bounds.size.width * oldAnchorPoint.x,
                                 view.bounds.size.height * oldAnchorPoint.y);
  CGPoint newPoint = CGPointMake(view.bounds.size.width * newAnchorPoint.x,
                                 view.bounds.size.height * newAnchorPoint.y);
  
  // Calculate the transformed anchorPoints, so the vector between them
  // represents the displacement as seen from the superview
  oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
  newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
  
  // Calculate the delta between the anchorPoints
  CGPoint const delta = CGPointMake(newPoint.x-oldPoint.x, newPoint.y-oldPoint.y);
  
  // get the x & y constraints constants which were contributing to the current
  // view's position, and whose constant param we will tweak to adjust its position
  CGFloat const oldXConstraintConstant = xConstraint.constant;
  CGFloat const oldYConstraintConstant = yConstraint.constant;
  
  // calculate new values for the x & y constraints, from the delta in anchorPoint
  // when autolayout recalculates the layout from the modified constraints,
  // it will set a new view.center that compensates for the affect of the anchorPoint
  CGFloat const newXConstraintConstant = oldXConstraintConstant + delta.x;
  CGFloat const newYConstraintConstant = oldYConstraintConstant + delta.y;
  
  NSLog(@"delta applied=%@",NSStringFromCGPoint(delta));
  view.layer.anchorPoint = newAnchorPoint;
  xConstraint.constant = newXConstraintConstant;
  yConstraint.constant = newYConstraintConstant;
  [view setNeedsLayout];
}

void AddBorderToLayerOfView(UIView * view) {
  CALayer * layer = view.layer;
  layer.borderColor = [[UIColor blueColor] CGColor];
  layer.borderWidth = 2.0f;
}

/**
  Adds a sublayer to view, drawing rect.
 */
CALayer * AddRectToView(UIView * view, CGRect rect, UIColor * color)
{
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
 Adds a crosshairs sublayer to view at point
 
 @param point bullseye of crosshairs, in view's coordinates
 @return the sublayer with the crosshairs image
 */
CALayer * AddCrossHairsToView(UIView * view, CGPoint point) {
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
  return AddCrossHairsToView(view, anchorPointInViewCoords);
}

