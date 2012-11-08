//
//  ViewController.m
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-08.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import "ViewController.h"

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

void LogLayoutPropertiesOfUIView(UIView *rootView,NSString * viewName) {
  NSLog(@"%@=%@",viewName,rootView);
  NSLog(@"%@.translatesAutoresizingMaskIntoConstraints=%@",viewName,NSStringFromBOOL(rootView.translatesAutoresizingMaskIntoConstraints));
  NSLog(@"%@.autoresizingMask=%@",viewName,NSStringFromUIViewAutoResizing(rootView.autoresizingMask));
  NSLog(@"%@.constraints=%@",viewName,rootView.constraints);
}


@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIView * rootView = self.view;
  UIView * greybox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  greybox.backgroundColor = [UIColor lightGrayColor];

  // stop autolayout from translating the default (all fixed) autoresizingmask into constraints
  greybox.translatesAutoresizingMaskIntoConstraints =NO;
 
 
  [rootView addSubview:greybox];

  LogLayoutPropertiesOfUIView(rootView, @"rootView");
  LogLayoutPropertiesOfUIView(greybox, @"greybox");

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
  UIView * rootView = self.view;
  NSLog(@"rootView.recursiveDescription=\n%@",[rootView recursiveDescription]);
}
@end
