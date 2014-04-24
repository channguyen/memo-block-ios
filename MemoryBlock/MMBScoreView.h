//
//  MMBScoreView.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBScoreView : UIView

@property (strong, nonatomic) IBOutlet UILabel *labelScore;
@property (strong, nonatomic) IBOutlet UILabel *labelHeader;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (assign, nonatomic) NSInteger score;

- (void)setHeaderLabel:(NSString *)label;
- (void)addScoreToCurrent:(NSInteger)score;
- (void)setCurrentScore:(NSInteger)score;

@end
