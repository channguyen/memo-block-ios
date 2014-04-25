//
//  MMBSoundManager.h
//  MemoryBlock
//
//  Created by chan on 4/25/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MMBSoundManager : NSObject

@property (nonatomic, readonly, assign) SystemSoundID moveSoundId;
@property (nonatomic, readonly, assign) SystemSoundID wrongMoveSoundId;
@property (nonatomic, readonly, assign) SystemSoundID completeMoveSoundId;
@property (nonatomic, assign) BOOL mute;

- (void)playMoveSound;
- (void)playWrongMoveSound;
- (void)playCompleteMoveSound;
- (void)dispose;

@end
