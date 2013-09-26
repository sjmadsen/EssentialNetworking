//
//  SessionGetViewController.m
//  NSURLSessionBasics
//
//  Created by Steve Madsen on 9/26/13.
//  Copyright (c) 2013 Light Year Software, LLC. All rights reserved.
//

#import "SessionGetViewController.h"

@interface SessionGetViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction) doRequest:(id)sender;

@end

@implementation SessionGetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.text = @"";
}

- (NSURLRequest *)makeRequest
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:4567/random-words"]];
}

- (void)doRequest:(id)sender
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[self makeRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                [self updateTextViewWithData:data];
            } else {
                [self updateTextViewWithError:error];
            }
        });
    }];
    [task resume];
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
