//
//  MMBGameViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBGameViewController.h"
#import "MMBAppDelegate.h"
#import "MMBPatternView.h"
#import "HighScore.h"
#import "MMBPatternGrid.h"
#import "MMBCell.h"

static const long MMBClearBlockTime = 2;

@interface MMBGameViewController () {
    MMBPatternGrid *_patternGrid;
}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation MMBGameViewController

- (id)init {
    self = [super initWithNibName:@"MMBGameViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    // Set new grid now
    self.patternView.delegate = self;
    [self makeNewGameWithRow:5 column:5];
    
    // Load preferences 
    MMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Schedule a new timer to clear all the blocks
    [NSTimer scheduledTimerWithTimeInterval:MMBClearBlockTime target:self selector:@selector(clearBlocks:) userInfo:nil repeats:NO];
}
     
- (void)clearBlocks:(NSTimer *)timer {
    [self.patternView acceptTouchesAndClearBlock];
}

- (void)makeNewGameWithRow:(NSInteger)row column:(NSInteger)column {
    _patternGrid = [[MMBPatternGrid alloc] initWithRow:row column:column];
    [_patternView setPatternGrid:_patternGrid];
    [_patternView setActiveCell:[[MMBCell alloc] initWithRow:-1 column:-1] toState:NEUTRAL];
    [_patternView setNeedsDisplay];
    [NSTimer scheduledTimerWithTimeInterval:MMBClearBlockTime target:self selector:@selector(clearBlocks:) userInfo:nil repeats:NO];
}

- (void)makeNewGame {
    [self makeNewGameWithRow:5 column:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isWrongMoveCell:(MMBCell *)cell {
    return ![_patternGrid isMarkedAtRow:cell.row column:cell.column];
}

- (BOOL)isWinningMoveCell:(MMBCell *)cell {
    return [_patternGrid numberOfMarkBeingRemoved] == [_patternGrid count];
}

- (void)patternView:(MMBPatternView *)patternView makeMoveAtCell:(MMBCell *)cell {
    [_patternGrid removeMarkAt:cell.row column:cell.column];
    if ([self isWrongMoveCell:cell]) {
        [_patternView setActiveCell:cell toState:LOST];
        [_patternView displayPattern];
        [_patternView rejectTouches];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(makeNewGame) userInfo:nil repeats:NO];
    } else if ([self isWinningMoveCell:cell]) {
        [_patternView setActiveCell:cell toState:WON];
        [_patternView displayPattern];
        [_patternView rejectTouches];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(makeNewGame) userInfo:nil repeats:NO];
    }
    [_patternView setNeedsDisplay];
}

- (void)nextClick:(id)sender {
    [self.currentScoreView addScoreToCurrent:4];
    HighScore *hs = [NSEntityDescription insertNewObjectForEntityForName:@"HighScore" inManagedObjectContext:self.managedObjectContext];
    hs.score = [NSNumber numberWithInt:2048];
    hs.date = @"04-02-2014";
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Wait a minute, save failed? ....");
    }
}

@end
