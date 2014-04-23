//
//  MMBCell.m
//  MemoryBlock
//
//  Created by chan on 4/22/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBCell.h"

@implementation MMBCell

- (id)initWithRow:(NSInteger)row column:(NSInteger)column {
    self = [super init];
    if (self) {
        _row = row;
        _column = column;
    }
    return self;
}

- (BOOL)isEqualToCell:(MMBCell *)cell {
    return self.row == cell.row && self.column == cell.column;
}

@end
