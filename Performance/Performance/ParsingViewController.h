//
//  ParsingViewController.h
//  Performance
//
//  Created by Steve Madsen on 8/4/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParsingViewController : UIViewController <NSXMLParserDelegate>

@property IBOutlet UILabel *xmlTimeLabel;
@property IBOutlet UILabel *jsonTimeLabel;
@property IBOutlet UILabel *plistTimeLabel;

@end
