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

#define M_TAU (M_PI * 2.0f)

static BOOL const USE_ADJUSTED_ANCHORPOINT = YES;
static BOOL const USE_CENTER_CONSTRAINT_NOT_EDGES = NO;

@interface ViewController ()
@property (weak,nonatomic) UIView * overlayView;
@property (weak,nonatomic) UIView * greyboxView;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSLog(@"USE_ADJUSTED_ANCHORPOINT=%@",NSStringFromBOOL(USE_ADJUSTED_ANCHORPOINT));
  NSLog(@"USE_CENTER_CONSTRAINT_NOT_EDGES=%@",NSStringFromBOOL(USE_CENTER_CONSTRAINT_NOT_EDGES));
  UIView * rootView = self.view;
  
  //
  // make global overlay view, for drawing annotations
  //
  
  UIView * theOverlayView =[[UIView alloc] initWithFrame:rootView.bounds];
  [self.view addSubview:theOverlayView];
  self.overlayView = theOverlayView;
  self.overlayView.backgroundColor = nil;
  self.overlayView.opaque = NO;
  self.overlayView.autoresizingMask = UIViewAutoresizingNone;
  self.overlayView.translatesAutoresizingMaskIntoConstraints = YES;
  
  //
  // add a square grey box
  //
  
  InstrumentedView * greybox = [[InstrumentedView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
  [rootView insertSubview:greybox belowSubview:theOverlayView];
  self.greyboxView = greybox;
  greybox.backgroundColor = [UIColor lightGrayColor];
  greybox.autoresizingMask = UIViewAutoresizingNone;
#ifdef USING_AUTOLAYOUT
  greybox.translatesAutoresizingMaskIntoConstraints = NO;
  NSLayoutConstraint * xConstraint;
  NSLayoutConstraint * yConstraint;
  if (USE_CENTER_CONSTRAINT_NOT_EDGES) {
    xConstraint = [NSLayoutConstraint constraintWithItem:greybox
                                               attribute:NSLayoutAttributeCenterX
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:greybox.superview
                                               attribute:NSLayoutAttributeLeft
                                              multiplier:1.0 constant:150.0];
    yConstraint = [NSLayoutConstraint constraintWithItem:greybox
                                               attribute:NSLayoutAttributeCenterY
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:greybox.superview
                                               attribute:NSLayoutAttributeTop
                                              multiplier:1.0 constant:150.0];
  }
  else
  {
    xConstraint = [NSLayoutConstraint constraintWithItem:greybox
                                               attribute:NSLayoutAttributeLeft
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:greybox.superview
                                               attribute:NSLayoutAttributeLeft
                                              multiplier:1.0 constant:100.0];
    yConstraint = [NSLayoutConstraint constraintWithItem:greybox
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:greybox.superview
                                               attribute:NSLayoutAttributeTop
                                              multiplier:1.0 constant:100.0];
  }
  
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
  

  // apply transforms to the view
  greybox.transform = CGAffineTransformIdentity;

 greybox.transform = CGAffineTransformRotate(greybox.transform, M_TAU / 40.0);
  greybox.transform = CGAffineTransformScale(greybox.transform, 1.5, 1.0);
  greybox.transform = CGAffineTransformTranslate(greybox.transform, 20.f, 0.0f);

  
  // set the anchorPoint
  CGPoint newAnchorPoint  = CGPointMake(0.0, 0.5);
  if (!USE_ADJUSTED_ANCHORPOINT) {
    greybox.layer.anchorPoint = newAnchorPoint;
  }
  else {
#ifdef USING_AUTOLAYOUT
    SetViewAnchorPointMotionlesslyUpdatingConstraints(greybox, newAnchorPoint,
                                                      xConstraint,yConstraint);
#else
    SetViewAnchorPointMotionlessly(greybox, newAnchorPoint);
#endif
    [greybox setNeedsLayout];
  }
  
}

-(void)viewDidAppear:(BOOL)animated
{
  UIView * rootView = self.view;
  InstrumentedView * greybox = (InstrumentedView*) self.greyboxView;
  
  // enable instrumentation
  [greybox strokeBounds];
  
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
  AddRectToView(self.overlayView,
                [self.overlayView convertRect:greybox.frame fromView:greybox.superview],
                [UIColor greenColor]);

  
  LogLayoutPropertiesOfUIView(greybox, @"greybox");
  LogPoint(greybox.center, @"greybox.center");
  LogPoint(CGPointGetCenter(greybox.frame), @"computed center of greybox.frame");
  NSLog(@"greybox.bounds=%@",NSStringFromCGRect(greybox.bounds));
  NSLog(@"greybox.frame=%@",NSStringFromCGRect(greybox.frame));
  NSLog(@"[greybox alignmentRectForFrame:greybox.frame]=%@",NSStringFromCGRect([greybox alignmentRectForFrame:greybox.frame]));
}
@end
