// //  MMBHighScoreViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBHighScoreViewController.h"
#import "MMBScoreViewCell.h"
#import "MMBAppDelegate.h"
#import "HighScore.h"
#import "MMBColorUtility.h"

@interface MMBHighScoreViewController () {
    NSMutableArray *_colorArray;
}
@end

@implementation MMBHighScoreViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navigationItem = self.navigationItem;
        navigationItem.title = @"High Score";
        _highScoreArray = [[NSMutableArray alloc] init];
        _colorArray = [[NSMutableArray alloc] init];
        [_colorArray addObject:UICOLOR_HEX(0xee5e62)];
        [_colorArray addObject:UICOLOR_HEX(0xee6e1a)];
        [_colorArray addObject:UICOLOR_HEX(0xd4c5d4)];
        [_colorArray addObject:UICOLOR_HEX(0xe1533c)];
        [_colorArray addObject:UICOLOR_HEX(0x00aaee)];
        [_colorArray addObject:UICOLOR_HEX(0xf2b8b2)];
        [_colorArray addObject:UICOLOR_HEX(0x108a8e)];
        [_colorArray addObject:UICOLOR_HEX(0xff5e62)];
        [_colorArray addObject:UICOLOR_HEX(0xe15100)];
        [_colorArray addObject:UICOLOR_HEX(0xaa5eb2)];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UICOLOR_HEX(0xE6D8CC)];
    UINib *nib = [UINib nibWithNibName:@"MMBScoreViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MMBScoreViewCell"];
    MMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    _highScoreArray = [[appDelegate fetchAllHighScore] mutableCopy];
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
    HighScore *highScore = _highScoreArray[indexPath.row];
    int idx = arc4random() % _colorArray.count;
    NSLog(@"index = %d", idx);
    [cell.labelScore setTextColor:_colorArray[idx]];
    [cell.labelScore setText:[highScore.score stringValue]];
    [cell.labelDate setTextColor:_colorArray[idx]];
    [cell.labelDate setText:[self readableTimeStamp:highScore.date]];
    return cell;
}

- (NSString *)readableTimeStamp:(NSString *)dateString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *component = [calendar components:flags fromDate:date toDate:now options:0];
    int year = (int)[component year];
    int month = (int)[component month];
    int day = (int)[component day];
    int hour = (int)[component hour];
    int minute = (int)[component minute];
    if (year > 0) {
        return [NSString stringWithFormat:@"%d years ago", year];
    }
    if (month > 0) {
        return [NSString stringWithFormat:@"%d months ago", month];
    }
    if (day > 0) {
        return [NSString stringWithFormat:@"%d days ago", day];
    }
    if (hour > 0) {
        return [NSString stringWithFormat:@"%d hours ago", hour];
    }
    if (minute > 0) {
        return [NSString stringWithFormat:@"%d minutes ago", minute];
    }
    return [NSString stringWithFormat:@"just now"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *msg = [NSString stringWithFormat:@"Select row= %d", (int)indexPath.row];
    NSLog(@"%@", msg);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
