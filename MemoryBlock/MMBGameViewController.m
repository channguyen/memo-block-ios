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
#import "NSTimer+Block.h"

static const double GVClearBlockDelayTime = 1.0;
static const double GVNextGameDelayTime = 0.5;
static const double GVClockTickTime = 1.0;

static const int GVMinimumRow = 3;
static const int GVMinimumColumn = 3;
static const int GVMaximumRow = 5;
static const int GVMaximumColumn = 5;
static const int GVTotalGameTime = 61;

@interface MMBGameViewController () {
    int currentRow;
    int currentColumn;
    int currentScore;
    int clockCounter;
    
    NSTimer *clockTimer;
    
    MMBSoundManager *soundManager;
    MMBPatternGrid *patternGrid;
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
    [self.patternView setBackgroundColor:UICOLOR_HEX(0xE6D8CC)];
    
    // Set up score label
    [self.currentScoreView setHeaderLabel:@"Score"];
    [self.currentScoreView setCurrentScore:0];
    [self.bestScoreView setHeaderLabel:@"Best Score"];
    [self.bestScoreView setCurrentScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"]];
   
    // Load preferences 
    MMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
   // Initialize sound manager
    soundManager = [[MMBSoundManager alloc] init];
    
    // Start new game
    self.patternView.delegate = self;
    
    // Check for new settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enableSound = [defaults boolForKey:@"soundSwitch"];
    soundManager.mute = !enableSound;
    BOOL enableClock = [defaults boolForKey:@"clockSwitch"];
    self.labelClock.hidden = !enableClock;
    
    // Launch new game now
    [self restartNewGame];
}

- (void)restartNewGame {
    currentRow = GVMinimumRow;
    currentColumn = GVMinimumColumn;
    currentScore = 0;
    clockCounter = 0;
    [self startNewGameWithRow:currentRow column:currentColumn];
    __weak MMBGameViewController *weakSelf = self;
    clockTimer = [NSTimer scheduledTimerWithTimeInterval:GVClockTickTime 
                                                   block:^{
                                                       MMBGameViewController *strongSelf = weakSelf;
                                                       [strongSelf tick];
                                                   }
                                                 repeats:YES];
                                                
}

- (void)clearBlock:(NSTimer *)timer {
    NSLog(@"clearBlock:timer");
    self.patternView.showPattern = NO;
    self.patternView.touchable = YES;
    [self.patternView setNeedsDisplay];
}

- (void)tick {
    clockCounter++;
    if (clockCounter < GVTotalGameTime) {
        [self.labelClock setText:[NSString stringWithFormat:@"00:%02d", clockCounter]];
    } else {
        [clockTimer invalidate];
        [self.labelClock setText:@"Time out"];
        self.patternView.touchable = NO;
        self.patternView.showPattern = NO;
        [self.patternView setNeedsDisplay];
        [self showCongratsDialog];
    }
}

- (void)setUpNewPatternWithRow:(NSInteger)row column:(NSInteger)column {
    MMBCell *cell = [[MMBCell alloc] initWithRow:-1 column:-1];
    [self.patternView setActiveCell:cell toState:NEUTRAL];
    patternGrid = [[MMBPatternGrid alloc] initWithRow:row column:column];
    [patternGrid generateNewGrid:row column:column];
    [self.patternView setPatternGrid:patternGrid];
    self.patternView.touchable = NO;
    self.patternView.showPattern = YES;
    [self.patternView setNeedsDisplay];
}

- (void)startNewGameWithRow:(NSInteger)row column:(NSInteger)column {
    [self setUpNewPatternWithRow:row column:column];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GVClearBlockDelayTime * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^(void) {
        NSLog(@"Hide pattern now...");
        self.patternView.showPattern = NO;
        self.patternView.touchable = YES;
        [self.patternView setNeedsDisplay];    
    });
}

- (int)nextRow {
    currentRow++;
    if (currentRow > GVMaximumRow) {
        currentRow = GVMaximumRow;
    }
    return currentRow;
}

- (int)nextColumn {
    currentColumn++;
    if (currentColumn > GVMaximumColumn) {
        currentColumn = GVMaximumColumn;
    }
    return currentColumn;
}

- (NSString *)currentDateTimeString {
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)saveScore:(NSInteger)score {
    HighScore *hs = [NSEntityDescription insertNewObjectForEntityForName:@"HighScore" inManagedObjectContext:self.managedObjectContext];
    hs.score = [NSNumber numberWithInteger:score];
    hs.date = [self currentDateTimeString];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Wait a minute, save failed? ....");
    }    
}

- (void)showCongratsDialog {
    NSString *msg = [NSString stringWithFormat:@"Your new highscore %d. Play another game?", (int)self.currentScoreView.score];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Yes", 
                                            nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger bestScore = [defaults integerForKey:@"bestScore"];
    // We only update the score if it's > 0
    if (currentScore > 0) {
        [self saveScore:currentScore];
    }
    if (currentScore > bestScore) {
        bestScore = currentScore;
        [self.bestScoreView setScore:bestScore];
        [defaults setInteger:bestScore forKey:@"bestScore"];
    }
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Cancel"]) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else {
        [self restartNewGame];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isWrongMoveCell:(MMBCell *)cell {
    return ![patternGrid isMarkedAtRow:cell.row column:cell.column];
}

- (BOOL)isWinningMoveCell:(MMBCell *)cell {
    return [patternGrid numberOfMarkBeingRemoved] == [patternGrid count];
}

- (void)resetClockTimer {
    [clockTimer invalidate];
    clockTimer = nil;
}

- (void)goToNextGameFromState:(MoveState)state {
    self.patternView.touchable = NO;
    self.patternView.showPattern = YES;
    if (clockCounter < GVTotalGameTime) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GVNextGameDelayTime * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^(void) {
            if (state == LOST) {
                [self startNewGameWithRow:currentRow column:currentColumn];
            } else {
                [self startNewGameWithRow:[self nextRow] column:[self nextColumn]];
            }
        });
    }
}

- (void)patternView:(MMBPatternView *)patternView makeMoveAtCell:(MMBCell *)cell {
    [soundManager playMoveSound];
    [patternGrid removeMarkAt:cell.row column:cell.column];
    if ([self isWrongMoveCell:cell]) {
        [self.patternView setActiveCell:cell toState:LOST];
        [self goToNextGameFromState:LOST];
    } else if ([self isWinningMoveCell:cell]) {
        [self.patternView setActiveCell:cell toState:WON];
        currentScore += patternGrid.score;
        [self.currentScoreView addScoreToCurrent:patternGrid.score];
        [self goToNextGameFromState:WON];
    }
    [self.patternView setNeedsDisplay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)dealloc {
    NSLog(@"dealloc");
    [soundManager dispose];
}

@end
