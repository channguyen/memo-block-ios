//
//  MMBRandomGridGenerator.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBRandomGridGenerator.h"

static const int MMBRandomNumber = 7;

@implementation MMBRandomGridGenerator

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSInteger)generateGrid:(int **)grid row:(NSInteger)row column:(NSInteger)column {
    int count = 0;
    for (int r = 0; r < row; ++r) {
        for (int c = 0; c < column; ++c) {
            if ((arc4random() % MMBRandomNumber) == 0) {
                grid[r][c] = 1;
                count++;
            } else {
                grid[r][c] = 0;
            }
        }
    }
    int randomRow = arc4random() % row;
    int randomColumn  = arc4random() % row;
    if (count == 0) {
        grid[randomRow][randomColumn] = 1;
        count++;
    }
    return count;
}

@end
