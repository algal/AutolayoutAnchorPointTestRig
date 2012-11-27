This rig is for examining how autolayout interacts with a view when view.anchorPoint and/or 
view.transform have non-default values.

To use:
- turn autolayout on/off using the #define in the .pch file in Supporting Files/
- switch between center- and edge- based constraints with the global in ViewController
- turn on/off "frame restoration" on anchorPoint with the global in ViewController

The problem:
- before autolayout, it was easy to set anchorPoint without moving the view by caching the frame
- before autolayout, it was easy to set anchorPoint in the presence of transforms without moving the view, by directly compensating for the transform
- after autolayout, you need to tweak layout constraints to set anchorpoint without  moving the view
- after autolayout, it's totally unclear how to compensate how to compensate for transforms in a way analogous to the world before autolayout, because autolayout tries to clobber the effects of some transforms but not others.
- when you're setting an anchorPoint, you're usually also setting a transform, so this is not a corner case

Observations:
- view.center is not the center of view.frame (when anchorPoint and/or transform is non-default)
- autolayout constraints view.center not the center of view frame.
- 


