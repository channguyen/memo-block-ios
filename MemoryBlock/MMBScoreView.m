//
//  MMBScoreView.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBScoreView.h"

@interface MMBScoreView ()

@end

@implementation MMBScoreView

@synthesize labelScore;
@synthesize score = _score;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MMBScoreView" owner:self options:nil];
        [self addSubview:self.view];
        [self setCurrentScore:0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MMBScoreView" owner:self options:nil];
        [self addSubview:self.view];
        [self setCurrentScore:0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.view];
}

- (void)addScoreToCurrent:(NSInteger)score {
    NSLog(@"Add score...");
    self.score += score;
    [self setCurrentScore:self.score];
}

- (void)setCurrentScore:(NSInteger)score {
    self.score = score;
    [self.labelScore setText:[NSString stringWithFormat:@"%ld", self.score]];
    [self.labelScore setNeedsDisplay];
}

@end
