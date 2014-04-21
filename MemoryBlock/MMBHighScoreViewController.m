//
//  MMBHighScoreViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBHighScoreViewController.h"
#import "MMBHighScore.h"
#import "MMBScoreViewCell.h"

@interface MMBHighScoreViewController ()

@end

@implementation MMBHighScoreViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navigationItem = self.navigationItem;
        navigationItem.title = @"Highscore";
        _highScoreArray = [[NSMutableArray alloc] init];
        [_highScoreArray addObject:[[MMBHighScore alloc] initWihtScore:100 date:@"Just now"]];
        [_highScoreArray addObject:[[MMBHighScore alloc] initWihtScore:101 date:@"2 hours ago"]];
        [_highScoreArray addObject:[[MMBHighScore alloc] initWihtScore:102 date:@"5 hours ago"]];
        [_highScoreArray addObject:[[MMBHighScore alloc] initWihtScore:103 date:@"24 days ago"]];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"MMBScoreViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MMBScoreViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillApear");
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_highScoreArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMBScoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMBScoreViewCell" forIndexPath:indexPath];
    MMBHighScore *highScore = _highScoreArray[indexPath.row];
    NSLog(@"%@", [NSString stringWithFormat:@"%ld, %@", highScore.score, highScore.date]);
    [[cell labelScore] setText:[NSString stringWithFormat:@"%ld", highScore.score]];
    [[cell labelDate] setText:highScore.date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *msg = [NSString stringWithFormat:@"Select row= %ld", indexPath.row];
    NSLog(@"%@", msg);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
