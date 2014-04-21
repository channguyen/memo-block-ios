//
//  MMBHighScore.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBHighScore.h"

@implementation MMBHighScore

- (id)initWihtScore:(NSInteger)score date:(NSString *)date {
    self = [super init];
    if (self) {
        _score = score;
        _date = date;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _score = [decoder decodeIntegerForKey:@"score"];
        _date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.score forKey:@"score"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (NSString *)description {
    NSString *s = [[NSString alloc] initWithFormat:@"Score %ld, when: %@", self.score, self.date];
    return s;
}

@end
