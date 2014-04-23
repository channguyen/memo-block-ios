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

@interface MMBGameViewController : UIViewController <MMBPatternViewDelegate>

@property (strong, nonatomic) IBOutlet MMBScoreView *currentScoreView;
@property (strong, nonatomic) IBOutlet MMBPatternView *patternView;
@property (strong, nonatomic) IBOutlet UIButton *buttonNext;

- (IBAction)nextClick:(id)sender;

@end