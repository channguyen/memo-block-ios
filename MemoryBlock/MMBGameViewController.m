//
//  MMBGameViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBGameViewController.h"
#import "MMBPatternView.h"

@interface MMBGameViewController ()

@end

@implementation MMBGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)patternView:(MMBPatternView *)patternView makeMove:(NSNumber *)correctNumber {
    BOOL correct = [correctNumber boolValue];
    NSLog(@"User makes move %@", correct ? @"YES" : @"NO");
}

- (void)nextClick:(id)sender {
    [self.currentScoreView addScoreToCurrent:4];
}

@end
