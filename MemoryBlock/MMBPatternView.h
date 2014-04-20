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

@protocol MMBPatternViewDelegate <NSObject>

@required
- (void)patternView:(MMBPatternView *)patternView makeMove:(NSNumber *)correct;
@end

@interface MMBPatternView : UIView

@property (strong, nonatomic) MMBPatternGrid *patternGrid;

@property (assign, nonatomic) BOOL showPattern;

@property (unsafe_unretained) id<MMBPatternViewDelegate> delegate;

@end
