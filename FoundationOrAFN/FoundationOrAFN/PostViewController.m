//
//  PostViewController.m
//  FoundationOrAFN
//
//  Created by Steve Madsen on 9/26/13.
//  Copyright (c) 2013 Light Year Software, LLC. All rights reserved.
//

#import "AFNetworking.h"

#import "PostViewController.h"

@interface PostViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *useAFN;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction) doRequest:(id)sender;

@end

@implementation PostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.text = @"";
    self.useAFN.on = NO;
    self.messageTextField.text = @"";
}

- (void)doRequest:(id)sender
{
    [self.messageTextField endEditing:YES];

    if (self.useAFN.on) {
        [self doRequestWithAFN];
    } else {
        [self doRequestWithFoundation];
    }
}

- (NSURL *) baseURL
{
    return [NSURL URLWithString:@"http://localhost:4567/"];
}

- (NSMutableURLRequest *)makeRequest
{
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"hash" relativeToURL:[self baseURL]]];
}

- (void)doRequestWithFoundation
{
    NSMutableURLRequest *request = [self makeRequest];
    [request setHTTPMethod:@"POST"];

#if 1 // application/x-www-form-urlencoded

    {
    NSString *parameters = [NSString stringWithFormat:@"message=%@", [self.messageTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    }

#else // multipart/form-data

    /*
     Content-Type: multipart/form-data; boundary=abc

     --abc
     Content-Disposition: form-data; name="message"; filename="message.txt"
     Content-Type: text/plain; charset=utf-8

     message value here
     --abc--
     */

    {
    NSString *boundary = [[NSUUID UUID] UUIDString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableString *body = [NSMutableString string];

    [body appendFormat:@"--%@\r\n", boundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"message\"; filename=\"message.txt\"\r\n"];
    [body appendFormat:@"Content-Type: text/plain; charset=utf-8\r\n\r\n"];
    [body appendFormat:@"%s", [self.messageTextField.text UTF8String]];
    [body appendFormat:@"\r\n--%@--\r\n", boundary];

    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }

#endif

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            [self updateTextViewWithData:data];
        } else {
            [self updateTextViewWithError:connectionError];
        }
    }];
}

- (void)doRequestWithAFN
{
    static AFHTTPClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [AFHTTPClient clientWithBaseURL:[self baseURL]];
    });

#if 1 // application/x-www-form-urlencoded

    {
    [client postPath:@"hash" parameters:@{ @"message": self.messageTextField.text } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updateTextViewWithData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self updateTextViewWithError:error];
    }];
    }

#else // multipart/form-data

    {
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"hash" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"message"];
    }];
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self updateTextViewWithData:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self updateTextViewWithError:error];
        }];
    [client enqueueHTTPRequestOperation:operation];
    }

#endif
}

- (void)updateTextViewWithData:(NSData *)data
{
    self.textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)updateTextViewWithError:(NSError *)error
{
    self.textView.text = [NSString stringWithFormat:@"Request failed: %@", [error localizedDescription]];
}

@end
