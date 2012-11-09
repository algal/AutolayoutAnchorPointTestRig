//
//  LayoutUtils.h
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-09.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

void SetViewAnchorPointMotionlessly(UIView * view, CGPoint anchorPoint);

void AddBorderToLayerOfView(UIView * view);

/**
 @param point bullseye of crosshairs, in view's coordinates
 @return the sublayer with the crosshairs image
 */
CALayer * AddCrossHairsSublayerToView(UIView * view, CGPoint point);

CALayer * AddCrosshairsSublayerToAnchorPointOfView(UIView * view);

CGPoint AnchorPointInSuperViewCoords(UIView *view);

