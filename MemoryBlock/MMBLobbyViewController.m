//
//  MMBLobbyViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBLobbyViewController.h"
#import "MMBGameViewController.h"
#import "MMBSettingsViewController.h"
#import "MMBColorUtility.h"
#import "MMBHighScoreListViewController.h"

@interface MMBLobbyViewController ()

@end

@implementation MMBLobbyViewController

- (id)init {
    self = [super initWithNibName:@"MMBLobbyViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UICOLOR_HEX(0xE6D8CC)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGameClick:(id)sender {
    MMBGameViewController *vc = [[MMBGameViewController alloc] initWithNibName:@"MMBGameViewController" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (IBAction)settingsClick:(id)sender {
    MMBSettingsViewController *vc = [[MMBSettingsViewController alloc] initWithNibName:@"MMBSettingsViewController" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (IBAction)highscoreClick:(id)sender {
    MMBHighScoreListViewController *vc = [[MMBHighScoreListViewController alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

@end
