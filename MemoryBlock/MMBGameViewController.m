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

@interface MMBGameViewController ()

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

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
    self.patternView.delegate = self;
    MMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
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
    HighScore *hs = [NSEntityDescription insertNewObjectForEntityForName:@"HighScore" inManagedObjectContext:self.managedObjectContext];
    hs.score = [NSNumber numberWithInt:2048];
    hs.date = @"04-02-2014";
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Wait a minute, save failed? ....");
    }
}

@end
