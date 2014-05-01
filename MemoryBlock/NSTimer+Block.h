//
//  NSTimer+Block.h
//  MemoryBlock
//
//  Created by chan on 4/30/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats;

@end
