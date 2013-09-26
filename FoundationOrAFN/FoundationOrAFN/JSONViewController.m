//
//  JSONViewController.m
//  FoundationOrAFN
//
//  Created by Steve Madsen on 9/26/13.
//  Copyright (c) 2013 Light Year Software, LLC. All rights reserved.
//

#import "AFNetworking.h"

#import "JSONViewController.h"

@interface JSONViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *useAFN;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction) doRequest:(id)sender;

@end

@implementation JSONViewController

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
    return [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:4567/random-words.json"]];
}

- (void)doRequestWithFoundation
{
    [NSURLConnection sendAsynchronousRequest:[self makeRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *json, NSError *connectionError) {
        if (json) {
            NSError *error;
            id things = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
            if (things) {
                [self updateTextViewWithThings:things];
            } else {
                [self updateTextViewWithError:error];
            }
        } else {
            [self updateTextViewWithError:connectionError];
        }
    }];
}

- (void)doRequestWithAFN
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self makeRequest] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self updateTextViewWithThings:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self updateTextViewWithError:error];
    }];
    [operation start];
}

- (void)updateTextViewWithThings:(id)things
{
    self.textView.text = [NSString stringWithFormat:@"%@", things];
}

- (void)updateTextViewWithError:(NSError *)error
{
    self.textView.text = [NSString stringWithFormat:@"Request failed: %@", [error localizedDescription]];
}

@end
