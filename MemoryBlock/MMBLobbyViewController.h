//
//  MMBLobbyViewController.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBLobbyViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonNewGame;
@property (strong, nonatomic) IBOutlet UIButton *buttonSettings;
@property (strong, nonatomic) IBOutlet UIButton *buttonHighscore;

- (IBAction)newGameClick:(id)sender;
- (IBAction)settingsClick:(id)sender;
- (IBAction)highscoreClick:(id)sender;

@end
