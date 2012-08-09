//
//  SynchronousViewController.m
//  NSURLConnectionBasics
//
//  Created by Steve Madsen on 7/31/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import "SynchronousViewController.h"
#import "../../Host.h"

@implementation SynchronousViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(startImageLoad)];
    [self.imageView addGestureRecognizer:tap];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void) startImageLoad
{
    NSURL *url = [NSURL URLWithString:@"http://" HOST ":4567/tarpit"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];

    /* On the device, we'll never get here because /tarpit simulates a
     * non-responsive (or very slow) server by sleeping for a long time before
     * returning anything. This sounds artificial, but the truth is that any
     * number of things can go wrong on the network that could permit this to
     * happen.
     *
     * On a device, if you block the main thread for too long, the system will
     * kill your app. Unfortunately, the watchdog does not seem to run in the
     * simulator. When combined with forgetting to test a network app with
     * poor network connectivity, it gives novices false confidence that
     * the app is working well. */

    self.imageView.image = [UIImage imageWithData:responseData];
}

@end
