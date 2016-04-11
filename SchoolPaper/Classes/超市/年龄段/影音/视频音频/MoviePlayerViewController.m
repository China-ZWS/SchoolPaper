//
//  MoviePlayerViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-15.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "MoviePlayerViewController.h"

@interface MoviePlayerViewController ()
{
    NSURL *_contentUrl;
}

@end
@implementation MoviePlayerViewController

- (id)initWithContentURL:(NSURL *)contentURL
{
    if ((self = [super initWithContentURL:contentURL]))
    {
        _contentUrl = contentURL;
        self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
//        self.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;//
//        self.movieSourceType = MPMovieControlModeDefault;
//        self.moviePlayer.moviewControlMode = 1;
    }
    return self;
}

- (void)moviePlayerPlaybackStateChanged:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
        {
            NSLog(@"MPMoviePlaybackStateStopped");
            break;
        }
            
        case MPMoviePlaybackStatePlaying:
        {
            NSLog(@"MPMoviePlaybackStatePlaying");
            break;
        }
            
        case MPMoviePlaybackStatePaused:
        {
            NSLog(@"MPMoviePlaybackStatePaused");
            break;
        }
            
        case MPMoviePlaybackStateInterrupted:
        {
            NSLog(@"MPMoviePlaybackStateInterrupted");
            break;
        }
            
        case MPMoviePlaybackStateSeekingForward:
        {
            NSLog(@"MPMoviePlaybackStateSeekingForward");
            break;
        }
            
        case MPMoviePlaybackStateSeekingBackward:
        {
            NSLog(@"MPMoviePlaybackStateSeekingBackward");
            break;
        }
    }
}

@end
