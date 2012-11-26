//
//  LayoutUtils.h
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-09.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

CGPoint GetAnchorPointInViewCoords(UIView *view);
CGPoint GetAnchorPointInSuperViewCoords(UIView *view);

void SetViewAnchorPointMotionlessly(UIView * view, CGPoint anchorPoint);

void SetViewAnchorPointMotionlesslyUpdatingConstraints(UIView * view,CGPoint anchorPoint,
                                                       NSLayoutConstraint * xConstraint,
                                                       NSLayoutConstraint * yConstraint);


void AddBorderToLayerOfView(UIView * view);
CALayer * AddRectLayerToView(UIView * view, CGRect rect);

/**
 @param point bullseye of crosshairs, in view's coordinates
 @return the sublayer with the crosshairs image
 */
CALayer * AddCrossHairsSublayerToView(UIView * view, CGPoint point);
CALayer * AddCrosshairsSublayerToAnchorPointOfView(UIView * view);

