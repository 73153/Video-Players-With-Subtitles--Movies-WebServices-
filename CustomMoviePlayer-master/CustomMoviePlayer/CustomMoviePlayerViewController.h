//
//  CustomMoviePlayerViewController.h
//  CustomMoviePlayer
//
//  Created by Joshua Grenon on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomUISlider.h"

@interface CustomMoviePlayerViewController : UIViewController {
    
    IBOutlet CustomUISlider *sliderTimeline;
    IBOutlet UIImageView *imgPreviewImage;
    
    IBOutlet UIToolbar *toolMovieControls;
    
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnFastForward;
    IBOutlet UIButton *btnRewind;
    
    NSString *filePath; 
        
    MPMoviePlayerController *moviePlayer;
    NSTimeInterval totalVideoTime; 
}

-(id)initWithMovieURL:(NSString *)fileURL;

@property(nonatomic, retain) IBOutlet UIImageView *imgPreviewImage;
@property(nonatomic, retain) IBOutlet CustomUISlider *sliderTimeline;

@property(nonatomic, retain) IBOutlet UIToolbar *toolMovieControls;
@property(nonatomic, retain) IBOutlet UIButton *btnPlay;
@property(nonatomic, retain) IBOutlet UIButton *btnFastForward;
@property(nonatomic, retain) IBOutlet UIButton *btnRewind;

@property(nonatomic, retain) NSString *filePath; 

@property(readwrite, retain) MPMoviePlayerController *moviePlayer;
@property(nonatomic, assign) NSTimeInterval totalVideoTime;

-(void)setMoviePlayerUserSettings;
-(IBAction)playMovie; 

-(IBAction)fastforward_touchdown; 
-(IBAction)fastforward_touchup; 

-(IBAction)rewind_touchdown; 
-(IBAction)rewind_touchup; 

-(void)monitorPlaybackTime;
-(IBAction)onTimeSliderChange:(UISlider*)sender;
 
-(void)setTotalVideoTimeDuration;
-(void)resetSlider;

-(IBAction)touchThumbImageDown;
-(IBAction)touchThumbImageUp;

@end