//
//  Benchmark.h
//  Performance
//
//  Created by Steve Madsen on 8/4/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Benchmark : NSObject

+ (uint64_t) absoluteTime;
+ (double) secondsSinceAbsoluteTime:(uint64_t)start;

+ (double) block:(void (^)(void))block;

@end
