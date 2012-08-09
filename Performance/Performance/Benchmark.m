//
//  Benchmark.m
//  Performance
//
//  Created by Steve Madsen on 8/4/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#include <mach/mach_time.h>

#import "Benchmark.h"

@implementation Benchmark

+ (uint64_t) absoluteTime
{
    return mach_absolute_time();
}

+ (double) secondsSinceAbsoluteTime:(uint64_t)start
{
    uint64_t stop = [self absoluteTime];

    static mach_timebase_info_data_t timebase_info;

    if (timebase_info.denom == 0)
    {
        mach_timebase_info(&timebase_info);
    }

    uint64_t elapsed = (stop - start) * timebase_info.numer / timebase_info.denom;

    return elapsed / 1000000000.0;
}

+ (double) block:(void (^)(void))block
{
    uint64_t start = [self absoluteTime];
    block();
    return [self secondsSinceAbsoluteTime:start];
}

@end
