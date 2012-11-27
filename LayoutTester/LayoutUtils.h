//
//  LayoutUtils.h
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-09.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * NSStringFromBOOL(BOOL flag);
NSString * NSStringFromUIViewAutoResizing(UIViewAutoresizing autoResizingMask);
void LogLayoutPropertiesOfUIView(UIView *view,NSString * viewName);
void LogPoint(CGPoint point, NSString * pointName);

CGPoint CGPointGetCenter(CGRect rect);

///

CGPoint GetAnchorPointInViewCoords(UIView *view);
CGPoint GetAnchorPointInSuperViewCoords(UIView *view);

void SetViewAnchorPointMotionlessly(UIView * view, CGPoint anchorPoint);

void SetViewAnchorPointMotionlesslyUpdatingConstraints(UIView * view,CGPoint anchorPoint,
                                                       NSLayoutConstraint * xConstraint,
                                                       NSLayoutConstraint * yConstraint);


void AddBorderToLayerOfView(UIView * view);
CALayer * AddRectToView(UIView * view, CGRect rect);

/**
 @param point bullseye of crosshairs, in view's coordinates
 @return the sublayer with the crosshairs image
 */
CALayer * AddCrossHairsToView(UIView * view, CGPoint point);
CALayer * AddCrosshairsSublayerToAnchorPointOfView(UIView * view);

