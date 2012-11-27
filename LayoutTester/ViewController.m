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
  self.overlayView.backgroundColor = nil;
  self.overlayView.opaque = NO;
  self.overlayView.autoresizingMask = UIViewAutoresizingNone;
  self.overlayView.translatesAutoresizingMaskIntoConstraints = YES;
  
  // add our text view, a grey box
  
  InstrumentedView * greybox = [[InstrumentedView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
  [rootView insertSubview:greybox belowSubview:theOverlayView];
  self.greyboxView = greybox;
  greybox.backgroundColor = [UIColor lightGrayColor];
  greybox.autoresizingMask = UIViewAutoresizingNone;
#ifdef USING_AUTOLAYOUT
  greybox.translatesAutoresizingMaskIntoConstraints = NO;
  NSLayoutConstraint * xConstraint = [NSLayoutConstraint constraintWithItem:greybox
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:greybox.superview
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:100.0];
  NSLayoutConstraint * yConstraint = [NSLayoutConstraint constraintWithItem:greybox
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:greybox.superview
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0 constant:100.0];

  NSLayoutConstraint * boxWidth = [NSLayoutConstraint constraintWithItem:greybox attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:0 constant:100.0];
  
  NSLayoutConstraint * boxHeight = [NSLayoutConstraint constraintWithItem:greybox
                                                                attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:0 constant:100.0];
  
  [rootView addConstraints:@[xConstraint,yConstraint,boxWidth,boxHeight]];
#endif
  
  LogLayoutPropertiesOfUIView(rootView, @"rootView");
  LogLayoutPropertiesOfUIView(greybox, @"greybox");
  
  // have not handled transforms correctly yet
  //  greybox.transform = CGAffineTransformMakeRotation( 0.3 );
//  greybox.transform = CGAffineTransformMakeScale(1.5, 1.0);

  CGPoint newAnchorPoint  = CGPointMake(1.0, 0.5);
#ifdef USING_AUTOLAYOUT
  SetViewAnchorPointMotionlesslyUpdatingConstraints(greybox, newAnchorPoint,
                                                    xConstraint,yConstraint);
#else
  SetViewAnchorPointMotionlessly(greybox, newAnchorPoint);
#endif

}

-(void)viewDidAppear:(BOOL)animated
{
  UIView * rootView = self.view;
  InstrumentedView * greybox = (InstrumentedView*) self.greyboxView;

  // enable instrumentation
  //  [greybox strokeBounds];
  
  //  [greybox addCrossHairsToAnchorPoint];
//  LogLayoutPropertiesOfUIView(rootView, @"rootView");
//  LogLayoutPropertiesOfUIView(greybox, @"greybox");

  // cross hairs on view.center
  AddCrossHairsToView(self.overlayView, [self.overlayView convertPoint:greybox.center
                                                              fromView:greybox.superview]);
  
  // cross hairs on computed view.center
  AddCrossHairsToView(self.overlayView, [self.overlayView convertPoint:CGPointGetCenter(greybox.frame)
                                                              fromView:greybox.superview]);
  
  // stroke the frame
  AddRectLayerToView(self.overlayView,
                     [self.overlayView convertRect:greybox.frame fromView:greybox.superview]);

 
  LogLayoutPropertiesOfUIView(greybox, @"greybox");
  LogPoint(CGPointGetCenter(greybox.frame), @"center of greybox.frame");
  LogPoint(greybox.center, @"greybox.center");
}
@end
