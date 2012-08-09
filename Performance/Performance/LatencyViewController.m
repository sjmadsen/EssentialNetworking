//
//  LatencyViewController.m
//  Performance
//
//  Created by Steve Madsen on 8/4/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import "LatencyViewController.h"
#import "../../Host.h"
#import "Benchmark.h"

static NSUInteger Iterations = 100;

typedef enum
{
    ModeIdle,
    ModeFetchingOne,
    ModeFetchingOneKeepAlive,
    ModeFetchingOnePipelined,
    ModeFetchingBatch
} Mode;

@implementation LatencyViewController
{
    Mode mode;
    NSUInteger completed;
    uint64_t startTime;
    NSMutableURLRequest *request;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    mode = ModeIdle;
    self.fetchOneTimeLabel.text = @"";
    self.fetchOneKeepAliveTimeLabel.text = @"";
    self.fetchOnePipelinedTimeLabel.text = @"";
    self.fetchBatchTimeLabel.text = @"";
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSMutableURLRequest *) buildRequestWithURL:(NSURL *)url
{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    theRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    return theRequest;
}

- (IBAction) fetchOne:(id)sender
{
    if (mode != ModeIdle)
    {
        return;
    }

    request = [self buildRequestWithURL:[NSURL URLWithString:@"http://" HOST ":8888/one.json"]];

    mode = ModeFetchingOne;
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    startTime = [Benchmark absoluteTime];
    completed = 0;
    for (NSUInteger count = 0; count < Iterations; ++count)
    {
        [self makeRequest];
    }
}

- (void) fetchOneComplete
{
    double elapsed = [Benchmark secondsSinceAbsoluteTime:startTime];
    double averageMillis = (elapsed / completed) * 1000;
    self.fetchOneTimeLabel.text = [NSString stringWithFormat:@"%.3fms", averageMillis];
    mode = ModeIdle;
    self.progressView.hidden = YES;
}

- (IBAction) fetchOneKeepAlive:(id)sender
{
    if (mode != ModeIdle)
    {
        return;
    }

    request = [self buildRequestWithURL:[NSURL URLWithString:@"http://" HOST ":8889/one.json"]];

    mode = ModeFetchingOneKeepAlive;
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    startTime = [Benchmark absoluteTime];
    completed = 0;
    for (NSUInteger count = 0; count < Iterations; ++count)
    {
        [self makeRequest];
    }
}

- (void) fetchOneKeepAliveComplete
{
    double elapsed = [Benchmark secondsSinceAbsoluteTime:startTime];
    double averageMillis = (elapsed / completed) * 1000;
    self.fetchOneKeepAliveTimeLabel.text = [NSString stringWithFormat:@"%.3fms", averageMillis];
    mode = ModeIdle;
    self.progressView.hidden = YES;
}

- (IBAction) fetchOnePipelined:(id)sender
{
    if (mode != ModeIdle)
    {
        return;
    }

    request = [self buildRequestWithURL:[NSURL URLWithString:@"http://" HOST ":8889/one.json"]];
    request.HTTPShouldUsePipelining = YES;

    mode = ModeFetchingOnePipelined;
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    startTime = [Benchmark absoluteTime];
    completed = 0;
    for (NSUInteger count = 0; count < Iterations; ++count)
    {
        [self makeRequest];
    }
}

- (void) fetchOnePipelinedComplete
{
    double elapsed = [Benchmark secondsSinceAbsoluteTime:startTime];
    double averageMillis = (elapsed / completed) * 1000;
    self.fetchOnePipelinedTimeLabel.text = [NSString stringWithFormat:@"%.3fms", averageMillis];
    mode = ModeIdle;
    self.progressView.hidden = YES;
}

- (IBAction) fetchBatch:(id)sender
{
    if (mode != ModeIdle)
    {
        return;
    }

    request = [self buildRequestWithURL:[NSURL URLWithString:@"http://" HOST ":8888/batch.json"]];
    mode = ModeFetchingBatch;
    startTime = [Benchmark absoluteTime];
    [self makeRequest];
}

- (void) fetchBatchComplete
{
    double elapsed = [Benchmark secondsSinceAbsoluteTime:startTime];
    double averageMillis = (elapsed / 100) * 1000;
    self.fetchBatchTimeLabel.text = [NSString stringWithFormat:@"%.3fms", averageMillis];
    mode = ModeIdle;
}

- (void) makeRequest
{
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error localizedDescription]);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    switch (mode)
    {
        case ModeIdle:
            break;
            
        case ModeFetchingOne:
            if (++completed == Iterations)
            {
                [self fetchOneComplete];
            }
            else
            {
                self.progressView.progress = (float)completed / Iterations;
            }
            break;

        case ModeFetchingOneKeepAlive:
            if (++completed == Iterations)
            {
                [self fetchOneKeepAliveComplete];
            }
            else
            {
                self.progressView.progress = (float)completed / Iterations;
            }
            break;

        case ModeFetchingOnePipelined:
            if (++completed == Iterations)
            {
                [self fetchOnePipelinedComplete];
            }
            else
            {
                self.progressView.progress = (float)completed / Iterations;
            }
            break;
            
        case ModeFetchingBatch:
            [self fetchBatchComplete];
            break;
    }
}

@end
