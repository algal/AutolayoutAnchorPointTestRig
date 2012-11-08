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
  layer.borderColor = [[UIColor redColor] CGColor];
  layer.borderWidth = 2.0f;
}

void AddSpotToAnchorPointOfView(UIView * view) {
  UIColor * const color = [UIColor redColor];
  CGFloat const crossHairDimension = 7.0f;
  

  CALayer * layer = view.layer;
  
  // draw a cross-hairs centered on the anchorpoint
  CGSize layerSize = layer.bounds.size;
  CGPoint anchorPointInLayerCoords = CGPointMake(layer.anchorPoint.x * layerSize.width,
                                                 layer.anchorPoint.x * layerSize.height);

  UIGraphicsBeginImageContextWithOptions(layerSize, NO, 0);
  CGContextRef c = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(c, [color CGColor]);

  CGContextMoveToPoint(c, anchorPointInLayerCoords.x - (crossHairDimension/2.0f), anchorPointInLayerCoords.y);
  CGContextAddLineToPoint(c, anchorPointInLayerCoords.x + (crossHairDimension/2.0f), anchorPointInLayerCoords.y);
  CGContextStrokePath(c);
  CGContextMoveToPoint(c,    anchorPointInLayerCoords.x,  anchorPointInLayerCoords.y - (crossHairDimension/2.0f));
  CGContextAddLineToPoint(c, anchorPointInLayerCoords.x , anchorPointInLayerCoords.y + (crossHairDimension/2.0f));
  CGContextStrokePath(c);
  
  UIImage * overlayImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  
  // add it to a spotlayer
  CALayer * spotLayer = [CALayer layer];
  spotLayer.frame = layer.bounds;
  spotLayer.contents = (id)[overlayImage CGImage];
  [layer addSublayer:spotLayer];


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

-(void)addSpot
{
  AddSpotToAnchorPointOfView(self);
}
@end
