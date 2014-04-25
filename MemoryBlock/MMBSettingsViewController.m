//
//  MMBSettingsViewController.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBSettingsViewController.h"
#import "MMBColorUtility.h"

@interface MMBSettingsViewController ()

@property (strong, nonatomic) NSArray *diffcultyArray;

@end

@implementation MMBSettingsViewController

- (id)init {
    self = [super initWithNibName:@"MMBSettingsViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UICOLOR_HEX(0xE6D8CC)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.soundSwitch setOn:[defaults boolForKey:@"soundSwitch"]];
    [self.clockSwitch setOn:[defaults boolForKey:@"clockSwitch"]];
    [self.soundSwitch addTarget:self action:@selector(flipSoundSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.clockSwitch addTarget:self action:@selector(flipClockSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)flipSoundSwitch:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.soundSwitch.isOn forKey:@"soundSwitch"];
}

- (IBAction)flipClockSwitch:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.clockSwitch.isOn forKey:@"clockSwitch"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
