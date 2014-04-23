//
//  MMBPatternGrid.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBGridGenerating.h"

@interface MMBPatternGrid : NSObject 

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign) NSInteger score;
@property id<MMBGridGenerating> algorithmDelegate;

- (id)initWithRow:(NSInteger)row column:(NSInteger)column;
- (NSInteger)moveCount;
- (void)generateNewGrid:(NSInteger)row column:(NSInteger)column;
- (BOOL)isMarkedAtRow:(NSInteger)row column:(NSInteger)column;
- (BOOL)isRemovedMarkAtRow:(NSInteger)row column:(NSInteger)column;
- (void)removeMarkAt:(NSInteger)row column:(NSInteger)column;
- (NSInteger)numberOfMarkBeingRemoved;
- (NSString *)description;

@end
