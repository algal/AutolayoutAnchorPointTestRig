//
//  ViewController.m
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-08.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

#import "LayoutUtils.h"
#import "InstrumentedView.h"

#ifdef DEBUG
@interface UIView (debug)
- (NSString *)recursiveDescription;
@end
#endif

@interface ViewController ()
@property (weak,nonatomic) UIView * overlayView;
@property (weak,nonatomic) UIView * greyboxView;
@end


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

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIView * rootView = self.view;
  
  //
  // make global overlay view
  //
  
  UIView * theOverlayView =[[UIView alloc] initWithFrame:rootView.bounds];
  [self.view addSubview:theOverlayView];
  self.overlayView = theOverlayView;
  theOverlayView.backgroundColor = nil;
  theOverlayView.opaque = NO;
  theOverlayView.autoresizingMask = UIViewAutoresizingNone;
  theOverlayView.translatesAutoresizingMaskIntoConstraints = YES;
  
  // add our text view, a grey box
  
  InstrumentedView * greybox = [[InstrumentedView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
  [rootView insertSubview:greybox belowSubview:theOverlayView];
  self.greyboxView = greybox;
  greybox.backgroundColor = [UIColor lightGrayColor];
  // stop autolayout from translating the default (all fixed) autoresizingmask into constraints
  greybox.autoresizingMask = UIViewAutoresizingNone;
#ifdef USING_AUTOLAYOUT
  greybox.translatesAutoresizingMaskIntoConstraints = NO;
  [rootView addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[greybox(100)]"
                                           options:0
                                           metrics:nil
                                             views:NSDictionaryOfVariableBindings(greybox)]];
  [rootView addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[greybox(100)]"
                                           options:0
                                           metrics:nil
                                             views:NSDictionaryOfVariableBindings(greybox)]];
#endif
  CGFloat fortyfivedegreesright = (M_PI * 2.0f) - (M_PI * 2.0f) / 8.f;
  NSLog(@"fortyfivedegreesright=%f",fortyfivedegreesright);
  greybox.transform = CGAffineTransformMakeRotation( 0.3 );
  
  LogLayoutPropertiesOfUIView(rootView, @"rootView");
  LogLayoutPropertiesOfUIView(greybox, @"greybox");
  
  SetViewAnchorPointMotionlessly(greybox, CGPointMake(1.0, 0.5));
  
  // enable instrumentation
  [greybox showBorder];

  //  [greybox addCrossHairsToAnchorPoint];
}

-(void)viewDidAppear:(BOOL)animated
{
  UIView * rootView = self.view;
  UIView * greybox = self.greyboxView;

//  LogLayoutPropertiesOfUIView(rootView, @"rootView");
//  LogLayoutPropertiesOfUIView(greybox, @"greybox");

//  AddCrossHairsSublayerToView(rootView, AnchorPointInSuperViewCoords(greybox));
  AddCrossHairsSublayerToView(rootView, greybox.center);

  // stroke the frame
  AddRectLayerToView(self.overlayView,
                     [self.overlayView convertRect:greybox.frame fromView:greybox.superview]);

 
  LogLayoutPropertiesOfUIView(greybox, @"greybox");
  LogPoint(CGPointGetCenter(greybox.frame), @"greybox.frame calculated center");
  LogPoint(greybox.center, @"greybox.center");
}
@end
