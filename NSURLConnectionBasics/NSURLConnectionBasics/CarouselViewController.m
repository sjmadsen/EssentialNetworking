//
//  CarouselViewController.m
//  NSURLConnectionBasics
//
//  Created by Steve Madsen on 7/31/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import "CarouselViewController.h"
#import "../../Host.h"

@implementation CarouselViewController
{
    NSMutableData *imageData;
}

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

#pragma mark - Networking

- (void) startImageLoad
{
    NSURL *url = [NSURL URLWithString:@"http://" HOST ":4567/image"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:self];
    [self.activityIndicator startAnimating];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    imageData = [NSMutableData data];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [imageData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.imageView.image = [UIImage imageWithData:imageData];
    [self.imageView sizeToFit];
    self.imageView.center = self.view.center;
    [self.activityIndicator stopAnimating];
}

@end
