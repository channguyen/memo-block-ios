//
//  MMBGameViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "MMBGameViewController.h"
#import "MMBAppDelegate.h"
#import "MMBPatternView.h"
#import "HighScore.h"
#import "MMBPatternGrid.h"
#import "MMBCell.h"
#import "MMBScoreView.h"
#import "MMBColorUtility.h"

static const double GVClearBlockDelayTime = 2.0;
static const double GVNextGameDelayTime = 1.0;

static const int GVMinimumRow = 4;
static const int GVMinimumColumn = 4;
static const int GVMaximumRow = 6;
static const int GVMaximumColumn = 6;
static const int GVTotalNumberOfGame = 10;

@interface MMBGameViewController () {
    MMBPatternGrid *_patternGrid;
    int _currentNumberOfRow;
    int _currentNumberOfColumn;
    int _currentGameCount;
    int _currentScore;
    
    SystemSoundID _moveSoundId;
    SystemSoundID _wrongMoveSoundId;
    SystemSoundID _completeMoveSoundId;
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
    
    [self.view setBackgroundColor:UICOLOR_HEX(0xE6D8CC)];
    [_patternView setBackgroundColor:UICOLOR_HEX(0xE6D8CC)];
    
    _currentNumberOfRow = GVMinimumRow;
    _currentNumberOfColumn = GVMinimumColumn;
    _currentScore = 0;
    
    // Set up score label
    [_currentScoreView setHeaderLabel:@"Score"];
    [_currentScoreView setCurrentScore:0];
    [_bestScoreView setHeaderLabel:@"Best Score"];
    [_bestScoreView setCurrentScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"]];
    
    // Set new grid now
    _patternView.delegate = self;
    [self makeNewGameWithRow:_currentNumberOfRow column:_currentNumberOfColumn];
    
    // Load preferences 
    MMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Schedule a new timer to clear all the blocks
    [NSTimer scheduledTimerWithTimeInterval:GVClearBlockDelayTime target:self selector:@selector(clearBlocks:) userInfo:nil repeats:NO];
    
    // Set up game sound
    NSURL *moveSoundURL = [[NSBundle mainBundle] URLForResource:@"tap" withExtension: @"aif"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)moveSoundURL, &_moveSoundId);
}

- (void)playMoveSound {
    AudioServicesPlaySystemSound(_moveSoundId);
}
     
- (void)clearBlocks:(NSTimer *)timer {
    [_patternView acceptTouchesAndClearBlock];
}

- (void)makeNewGameWithRow:(NSInteger)row column:(NSInteger)column {
    _currentScore = 0;
    _patternGrid = [[MMBPatternGrid alloc] initWithRow:row column:column];
    [_patternView setPatternGrid:_patternGrid];
    [_patternView setActiveCell:[[MMBCell alloc] initWithRow:-1 column:-1] toState:NEUTRAL];
    [_patternView setNeedsDisplay];
    [NSTimer scheduledTimerWithTimeInterval:GVClearBlockDelayTime target:self selector:@selector(clearBlocks:) userInfo:nil repeats:NO];
}

- (int)nextRow {
    _currentNumberOfRow++;
    if (_currentNumberOfRow > GVMaximumRow) {
        _currentNumberOfRow = GVMaximumRow;
    }
    return _currentNumberOfRow;
}

- (int)nextColumn {
    _currentNumberOfColumn++;
    if (_currentNumberOfColumn > GVMaximumColumn) {
        _currentNumberOfColumn = GVMaximumColumn;
    }
    return _currentNumberOfColumn;
}

- (BOOL)isLastGame {
    return _currentGameCount == GVTotalNumberOfGame;
}

- (void)makeNextGame:(NSTimer *)timer {
    NSDictionary *lastMoveInfo = [timer userInfo];
    MoveState state = [lastMoveInfo[@"state"] intValue];
    _currentGameCount++;
    if ([self isLastGame]) {
        [self showCongratsDialog];
    } else {
        if (state == WON) {
            [self makeNewGameWithRow:[self nextRow] column:[self nextColumn]];
        } else {
            [self makeNewGameWithRow:_currentNumberOfRow column:_currentNumberOfColumn];
        }
    }
}

- (void)makeNewGame {
    _currentNumberOfRow = GVMinimumRow;
    _currentNumberOfColumn = GVMinimumColumn;
    _currentGameCount = 0;
    [self makeNewGameWithRow:_currentNumberOfRow column:_currentNumberOfColumn];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"OK"]) {
        NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"];
        [self.currentScoreView setCurrentScore:0];
        [self.bestScoreView setCurrentScore:bestScore];
        [self makeNewGame];
    }
}

- (void)showCongratsDialog {
    NSString *msg = [NSString stringWithFormat:@"Your new highscore %d", self.currentScoreView.score];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger bestScore = [defaults integerForKey:@"bestScore"];
    NSInteger currentScore = self.currentScoreView.score;
    if (currentScore > bestScore) {
        bestScore = currentScore;
        [defaults setInteger:bestScore forKey:@"bestScore"];
    }
    [message show];
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
    [self playMoveSound];
    [_patternGrid removeMarkAt:cell.row column:cell.column];
    if ([self isWrongMoveCell:cell]) {
        [_patternView setActiveCell:cell toState:LOST];
        [_patternView displayPattern];
        [_patternView rejectTouches];
        NSDictionary *lastMoveInfo = @{@"state" : [NSNumber numberWithInt:LOST]};
        [NSTimer scheduledTimerWithTimeInterval:GVNextGameDelayTime target:self selector:@selector(makeNextGame:) userInfo:lastMoveInfo repeats:NO];
    } else if ([self isWinningMoveCell:cell]) {
        [_patternView setActiveCell:cell toState:WON];
        [_patternView displayPattern];
        [_patternView rejectTouches];
        NSDictionary *lastMoveInfo = @{@"state" : [NSNumber numberWithInt:WON]};
        [NSTimer scheduledTimerWithTimeInterval:GVNextGameDelayTime target:self selector:@selector(makeNextGame:) userInfo:lastMoveInfo repeats:NO];
        _currentScore += _patternGrid.score;
        NSLog(@"current score = %d", _currentScore);
        [_currentScoreView addScoreToCurrent:_patternGrid.score];
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

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(_moveSoundId);
}

@end
