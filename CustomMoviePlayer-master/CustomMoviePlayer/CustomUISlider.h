//
//  CustomUISlider.h
//  CustomMoviePlayer
//
//  Created by Joshua Grenon on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomUISlider : UISlider {
    
    NSTimeInterval totalVideoTime;
    BOOL IsTouch;
}

@property(nonatomic, assign) NSTimeInterval totalVideoTime;
@property(nonatomic, assign) BOOL IsTouch;

- (CGRect)thumbRect;

@end