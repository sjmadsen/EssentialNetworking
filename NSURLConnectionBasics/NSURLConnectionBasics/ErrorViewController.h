//
//  ErrorViewController.h
//  NSURLConnectionBasics
//
//  Created by Steve Madsen on 8/1/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorViewController : UIViewController
    <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property IBOutlet UITextView *textView;

@end
