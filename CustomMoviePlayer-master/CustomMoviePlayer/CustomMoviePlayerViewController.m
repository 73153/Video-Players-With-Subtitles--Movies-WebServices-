//
//  CustomMoviePlayerViewController.m
//  CustomMoviePlayer
//
//  Created by Joshua Grenon on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomMoviePlayerViewController.h"

@implementation CustomMoviePlayerViewController

@synthesize sliderTimeline;
@synthesize filePath;

@synthesize moviePlayer;
@synthesize totalVideoTime;
@synthesize imgPreviewImage;
@synthesize toolMovieControls;
@synthesize btnPlay;
@synthesize btnFastForward;
@synthesize btnRewind; 

- (void)dealloc
{
    [super dealloc];
}

-(id)initWithMovieURL:(NSString *)fileURL
{
    self.filePath = fileURL;
	[super initWithNibName:@"CustomMoviePlayerViewController" bundle:nil];	
	return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    //add video to subview
    NSURL *movieURL = [NSURL fileURLWithPath:self.filePath];
    
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
	if (mp)
	{
		// save the movie player object
		self.moviePlayer = mp;
		[mp release];
		
        //get movie preview image so there will be no blink when the movie starts
        [self performSelector:@selector(setTotalVideoTimeDuration) withObject:nil afterDelay:0.1];
        imgPreviewImage.image = [self.moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        imgPreviewImage.hidden = YES;
        
		// Apply the user specified settings to the movie player object
		[self setMoviePlayerUserSettings];
        self.moviePlayer.view.hidden = NO;
        self.moviePlayer.shouldAutoplay = NO;
		self.moviePlayer.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:moviePlayer.view];
        moviePlayer.view.frame = CGRectMake(20, 20, 728, 594);
    }
    
    NSLog(@"UISlider: %@",self.sliderTimeline.subviews);
}
    
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
    
-(void)playerPlaybackDidFinish:(NSNotification*)notification
{
    [btnPlay setImage:[UIImage imageNamed:@"UIButtonBarPlayGray.png"] forState:UIControlStateNormal];
    btnPlay.tag = 0;
}

-(void)resetSlider
{        
    [self.sliderTimeline setValue:0 animated:NO];
    self.moviePlayer.currentPlaybackTime = 0;
}

-(void)setTotalVideoTimeDuration
{    
    self.totalVideoTime = self.moviePlayer.duration;
    self.sliderTimeline.totalVideoTime = self.moviePlayer.duration;
    self.sliderTimeline.minimumValue = 0.0;
    self.sliderTimeline.maximumValue = self.moviePlayer.duration;
    self.moviePlayer.currentPlaybackTime = 0.1;
}

-(IBAction)onTimeSliderChange:(UISlider*)sender
{
    self.moviePlayer.currentPlaybackTime = sliderTimeline.value;  
}

-(IBAction)touchThumbImageDown
{    
    self.moviePlayer.currentPlaybackTime = sliderTimeline.value;  
}

-(IBAction)touchThumbImageUp
{
    self.sliderTimeline.IsTouch = NO;
}

-(IBAction)playMovie
{
    self.moviePlayer.view.hidden = NO;
    if (btnPlay.tag == 0) 
    {       
        if (self.totalVideoTime != 0 && self.moviePlayer.currentPlaybackTime >= totalVideoTime)
        {
            self.moviePlayer.currentPlaybackTime = 0;
            [self performSelector:@selector(resetSlider) withObject:nil afterDelay:0.1];
        }        
        
        [self monitorPlaybackTime];
        [self.moviePlayer play];
        
        [btnPlay setImage:[UIImage imageNamed:@"UIButtonBarPauseGray.png"] forState:UIControlStateNormal];
        btnPlay.tag = 1;
    }
    else if(btnPlay.tag == 1)
    {
        [self.moviePlayer pause];
        [btnPlay setImage:[UIImage imageNamed:@"UIButtonBarPlayGray.png"] forState:UIControlStateNormal];
        btnPlay.tag = 0;
    }          
}

-(IBAction)fastforward_touchdown
{
   self.moviePlayer.currentPlaybackRate = 5; 
}

-(IBAction)fastforward_touchup
{
   self.moviePlayer.currentPlaybackRate = 1; 
}

-(IBAction)rewind_touchdown
{
    self.moviePlayer.currentPlaybackRate = -5;
}

-(IBAction)rewind_touchup
{
    self.moviePlayer.currentPlaybackRate = 1;
}

-(void)monitorPlaybackTime
{
    if (self.sliderTimeline.IsTouch) 
        return;
    
    self.sliderTimeline.value = self.moviePlayer.currentPlaybackTime;
    NSLog(@"currenttime: %f",self.moviePlayer.currentPlaybackTime);
    
    //keep checking for the end of video
    if (self.totalVideoTime != 0 && self.moviePlayer.currentPlaybackTime >= totalVideoTime)
    {
        [self.moviePlayer pause];
        [btnPlay setImage:[UIImage imageNamed:@"UIButtonBarPlayGray.png"] forState:UIControlStateNormal];
        btnPlay.tag = 0;
    }
    else
    {
        [self performSelector:@selector(monitorPlaybackTime) withObject:nil afterDelay:0.1];
    }
}

-(void)setMoviePlayerUserSettings
{    
    /* 
     Movie scaling mode can be one of: MPMovieScalingModeNone, MPMovieScalingModeAspectFit,
     MPMovieScalingModeAspectFill, MPMovieScalingModeFill.
     */
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    //Dont show movie controls
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    /*
     The color of the background area behind the movie can be any UIColor value.
     */
	self.moviePlayer.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end