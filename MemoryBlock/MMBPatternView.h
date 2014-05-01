//
//  MMBPatternView.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMBPatternGrid;
@class MMBPatternView;
@class MMBCell;

typedef NS_ENUM(NSInteger, MoveState) {
    NEUTRAL,
    LOST,
    WON
};

@protocol MMBPatternViewDelegate <NSObject>

@required
- (void)patternView:(MMBPatternView *)patternView makeMoveAtCell:(MMBCell *)cell;
@end

@interface MMBPatternView : UIView

@property (unsafe_unretained) id<MMBPatternViewDelegate> delegate;
@property (assign, atomic) BOOL touchable;
@property (assign, atomic) BOOL showPattern;

- (void)setPatternGrid:(MMBPatternGrid *)patternGrid;
- (void)setActiveCell:(MMBCell *)cell toState:(MoveState)state;

@end
