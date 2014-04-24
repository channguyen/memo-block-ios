//
//  MMBPatternGrid.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBPatternGrid.h"
#import "MMBRandomGridGenerator.h"

static const int PGEmpty = 0;
static const int PGMarked = 1;
static const int PGMarkRemoved = 2;

@implementation MMBPatternGrid {
    int **_grid;
}

@synthesize row = _row;
@synthesize column = _column;
@synthesize count = _count;
@synthesize score = _score;

- (id)initWithRow:(NSInteger)row column:(NSInteger)column {
    if (self = [super init]) {
        _row = row;
        _column = column;
        _grid = [self allocateNewGrid:_row column:_column];
        for (int r = 0; r < _row; ++r) {
            for (int c = 0; c < _column; ++c) {
                _grid[r][c] = false;
            }
        }
        _algorithmDelegate = [[MMBRandomGridGenerator alloc] init];
        [self generateNewGrid:_row column:_column];
    }
    return self;
}

- (NSInteger)moveCount {
    return _count;
}

- (int **)allocateNewGrid:(NSInteger)row column:(NSInteger)column {
    int **p = malloc(row * sizeof(int *));
    for (int i = 0; i < row; ++i) {
        p[i] = malloc(column * sizeof(int));
    }
    return p;
}

- (void)generateNewGrid:(NSInteger)row column:(NSInteger)column {
    [self freeGrid];
    _grid = [self allocateNewGrid:row column:column];
    _count = [self.algorithmDelegate generateGrid:_grid row:row column:column];
    _score = _count * 5;
}

- (BOOL)isMarkedAtRow:(NSInteger)row column:(NSInteger)column {
    if (![self isValidRow:row column:column]) {
        return NO;
    }
    return _grid[row][column] == PGMarked || _grid[row][column] == PGMarkRemoved;
}

- (BOOL)isRemovedMarkAtRow:(NSInteger)row column:(NSInteger)column {
    if (![self isValidRow:row column:column]) {
        return NO;
    }
    return _grid[row][column] == PGMarkRemoved;
}

- (void)removeMarkAt:(NSInteger)row column:(NSInteger)column {
    if (![self isValidRow:row column:column] || _grid[row][column] == PGEmpty) {
        return;
    }
    _grid[row][column] = PGMarkRemoved;
}

- (BOOL)isValidRow:(NSInteger)row column:(NSInteger)column {
    return 0 <= row && row < self.row && 0 <= column && column < self.column;
}

- (void)freeGrid {
    NSLog(@"freeGrid");
    for (int i = 0; i < _row; ++i) {
        free(_grid[i]);
    }
    free(_grid);
}

- (void)dealloc {
    [self freeGrid];
}

- (NSString *)description {
    NSString *s = [NSString stringWithFormat:@""];
    for (int r = 0; r < self.row; ++r) {
        for (int c = 0; c < self.column; ++c) {
            [s stringByAppendingString:[NSString stringWithFormat:@"|%d|", _grid[r][c] ? 1 : 0]];
        }
        [s stringByAppendingString:@"\n"];
    }
    return s;
}

- (NSInteger)numberOfMarkBeingRemoved {
    int cnt = 0;
    for (int r = 0; r < _row; ++r) {
        for (int c = 0; c < _column; ++c) {
            if (_grid[r][c] == PGMarkRemoved) {
                cnt++;
            }
        }
    }
    return cnt;
}

@end
