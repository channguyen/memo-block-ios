//
//  MMBCell.h
//  MemoryBlock
//
//  Created by chan on 4/22/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMBCell : NSObject

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

- (id)initWithRow:(NSInteger)row column:(NSInteger)column;
- (BOOL)isEqualToCell:(MMBCell *)cell;

@end
