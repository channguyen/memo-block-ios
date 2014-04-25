//
//  MMBSoundManager.m
//  MemoryBlock
//
//  Created by chan on 4/25/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBSoundManager.h"

@implementation MMBSoundManager

- (id)init {
    self = [super init];
    if (self) {
        _mute = NO;
        NSURL *moveSoundURL = [[NSBundle mainBundle] URLForResource:@"tap" withExtension: @"aif"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)moveSoundURL, &_moveSoundId);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)moveSoundURL, &_wrongMoveSoundId);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)moveSoundURL, &_completeMoveSoundId);
    }
    return self;
}

- (void)playMoveSound {
    if (_mute == NO) {
        AudioServicesPlaySystemSound(_moveSoundId);
    }
}

- (void)playWrongMoveSound {
    if (_mute == NO) {
        AudioServicesPlaySystemSound(_wrongMoveSoundId);
    }
}

- (void)playCompleteMoveSound {
    if (_mute == NO) {
        AudioServicesPlaySystemSound(_completeMoveSoundId);
    }
}

- (void)dispose {
   AudioServicesDisposeSystemSoundID(_moveSoundId); 
}

@end
