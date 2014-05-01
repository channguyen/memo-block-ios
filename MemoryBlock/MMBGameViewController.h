//
//  MMBGameViewController.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBPatternView.h"
#import "MMBScoreView.h"
#import "MMBSoundManager.h"

@interface MMBGameViewController : UIViewController <MMBPatternViewDelegate>

@property (weak, nonatomic) IBOutlet MMBScoreView *currentScoreView;
@property (weak, nonatomic) IBOutlet MMBScoreView *bestScoreView;
@property (weak, nonatomic) IBOutlet MMBPatternView *patternView;
@property (weak, nonatomic) IBOutlet UILabel *labelGameTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelClock;

- (void)tick;

@end
