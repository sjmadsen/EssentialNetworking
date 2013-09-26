//
//  GetViewController.m
//  FoundationOrAFN
//
//  Created by Steve Madsen on 9/25/13.
//  Copyright (c) 2013 Light Year Software, LLC. All rights reserved.
//

#import "AFNetworking.h"

#import "GetViewController.h"

@interface GetViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *useAFN;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction) doRequest:(id)sender;

@end

@implementation GetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.text = @"";
    self.useAFN.on = NO;
}

- (void)doRequest:(id)sender
{
    if (self.useAFN.on) {
        [self doRequestWithAFN];
    } else {
        [self doRequestWithFoundation];
    }
}

- (NSURLRequest *)makeRequest
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:4567/random-words"]];
}

- (void)doRequestWithFoundation
{
    [NSURLConnection sendAsynchronousRequest:[self makeRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            [self updateTextViewWithData:data];
        } else {
            [self updateTextViewWithError:connectionError];
        }
    }];
}

- (void)doRequestWithAFN
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[self makeRequest]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updateTextViewWithData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self updateTextViewWithError:error];
    }];
    [operation start];
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
