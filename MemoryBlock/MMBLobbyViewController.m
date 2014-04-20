//
//  MMBLobbyViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBLobbyViewController.h"
#import "MMBGameViewController.h"

@interface MMBLobbyViewController ()

@end

@implementation MMBLobbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGameClick:(id)sender {
    MMBGameViewController *gameViewController = [[MMBGameViewController alloc] initWithNibName:@"MMBGameViewController" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:gameViewController animated:YES];
    });
}

- (IBAction)resumeClick:(id)sender {
    
}

- (IBAction)settingsClick:(id)sender {
    
}

- (IBAction)highscoreClick:(id)sender {
    
}

@end
