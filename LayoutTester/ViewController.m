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
  InstrumentedView * greybox = [[InstrumentedView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  greybox.backgroundColor = [UIColor lightGrayColor];

  // stop autolayout from translating the default (all fixed) autoresizingmask into constraints
  greybox.translatesAutoresizingMaskIntoConstraints =NO;
 
  [rootView addSubview:greybox];

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

//  LogLayoutPropertiesOfUIView(rootView, @"rootView");
//  LogLayoutPropertiesOfUIView(greybox, @"greybox");
  
  // enable instrumentation
  [greybox showBorder];
//  greybox.layer.anchorPoint = CGPointMake(0.75, greybox.layer.anchorPoint.y);

//  [greybox addCrossHairsToAnchorPoint];
}

-(void)viewDidAppear:(BOOL)animated
{
  UIView * rootView = self.view;
  UIView * greybox = [[self.view subviews] lastObject];

//  LogLayoutPropertiesOfUIView(rootView, @"rootView");
//  LogLayoutPropertiesOfUIView(greybox, @"greybox");

  AddCrossHairsSublayerToView(rootView, AnchorPointInSuperViewCoords(greybox));
}
@end
