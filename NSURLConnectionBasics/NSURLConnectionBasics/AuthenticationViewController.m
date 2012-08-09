//
//  AuthenticationViewController.m
//  NSURLConnectionBasics
//
//  Created by Steve Madsen on 7/31/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "../../Host.h"

@implementation AuthenticationViewController
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

- (void) startImageLoad
{
    NSURL *url = [NSURL URLWithString:@"http://" HOST ":4567/auth-image"];
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

/* Without the following two methods, requests to /auth-image will return a
 * 401 Not Authorized response. Uncomment these two methods and after an
 * initial 401, NSURLConnection will query its delegate for credentials and
 * retry the request. */

//- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    return YES;
//}
//
//- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user"
//                                                             password:@"password"
//                                                          persistence:NSURLCredentialPersistenceForSession];
//    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//}

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
    if (self.imageView.image)
    {
        [self.imageView sizeToFit];
    }
    self.imageView.center = self.view.center;
}

@end
