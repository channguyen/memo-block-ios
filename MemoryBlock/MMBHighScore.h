//
//  MMBHighScore.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMBHighScore : NSObject

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger score;

- (id)initWihtScore:(NSInteger)score date:(NSString *)date;

@end
