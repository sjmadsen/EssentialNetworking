//
//  LatencyViewController.h
//  Performance
//
//  Created by Steve Madsen on 8/4/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatencyViewController : UIViewController
    <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property IBOutlet UIProgressView *progressView;
@property IBOutlet UILabel *fetchOneTimeLabel;
@property IBOutlet UILabel *fetchOneKeepAliveTimeLabel;
@property IBOutlet UILabel *fetchOnePipelinedTimeLabel;
@property IBOutlet UILabel *fetchBatchTimeLabel;

- (IBAction) fetchOne:(id)sender;
- (IBAction) fetchOneKeepAlive:(id)sender;
- (IBAction) fetchOnePipelined:(id)sender;
- (IBAction) fetchBatch:(id)sender;

@end
