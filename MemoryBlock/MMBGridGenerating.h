//
//  MMBGridGenerating.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMBGridGenerating <NSObject>

@required
- (NSInteger) generateGrid:(int **)grid row:(NSInteger)row column:(NSInteger)column;

@end
