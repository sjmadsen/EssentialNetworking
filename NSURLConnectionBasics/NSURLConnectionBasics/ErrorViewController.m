//
//  ErrorViewController.m
//  NSURLConnectionBasics
//
//  Created by Steve Madsen on 8/1/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import "ErrorViewController.h"
#import "../../Host.h"

@implementation ErrorViewController
{
    NSHTTPURLResponse *response;
    NSMutableData *responseData;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(startImageLoad)];
    [self.textView addGestureRecognizer:tap];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Networking

- (void) startImageLoad
{
    NSURL *url = [NSURL URLWithString:@"http://" HOST ":4567/nothing-here"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:self];
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

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response
{
    response = (NSHTTPURLResponse *)_response;
    responseData = [NSMutableData data];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableString *responseHeaders = [NSMutableString string];
    for (id key in response.allHeaderFields)
    {
        [responseHeaders appendFormat:@"%@: %@\n", key, [response.allHeaderFields objectForKey:key]];
    }

    NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    self.textView.text = [NSString stringWithFormat:@"%@\n%@",
                          responseHeaders, responseBody];
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // OK
}

@end
