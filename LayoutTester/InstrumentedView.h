//
//  InstrumentedView.h
//  LayoutTester
//
//  Created by Alexis Gallagher on 2012-11-08.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstrumentedView : UIView
-(void)showBorder;
-(void)addSpot;
-(void)addCrossHairs:(CGPoint)point;
@end
