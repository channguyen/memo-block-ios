//
//  MMBPatternView.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBPatternView.h"
#import "MMBPatternGrid.h"
#import "MMBCell.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define HEX(c)       [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

static const float MMBThickness = 4.0f;

@interface MMBPatternView() {
    UIColor *_borderColor;
    UIColor *_emptySquareColor;
    UIColor *_patternSquareColor;
    UIColor *_wrongSquareColor;
    UIImage *_crossImage;
    UIImage *_checkImage;
    BOOL _touchable;
    BOOL _patternShow;
    BOOL _madeWrongMove;
    MMBCell *_activeCell;
    MoveState _moveState;
    MMBPatternGrid *_patternGrid;
}
@end

@implementation MMBPatternView

- (id)initCommon {
    self.userInteractionEnabled = YES;
    
    // Private
    _borderColor = HEX(0x31748f);
    _emptySquareColor = HEX(0xe6e6fa);
    _patternSquareColor = HEX(0xff3016);
    _wrongSquareColor = HEX(0x000000);
    _activeCell = [[MMBCell alloc] initWithRow:-1 column:-1];
    _touchable = NO;
    _patternShow = YES;
    _madeWrongMove = NO;
    _moveState = WON;
    _crossImage = [UIImage imageNamed:@"wrong_marker.png"];
    _checkImage = [UIImage imageNamed:@"correct_marker.png"];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self initCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self = [self initCommon];
    }
    return self;
}

- (void)setPatternGrid:(MMBPatternGrid *)newPatternGrid {
    _patternGrid = newPatternGrid;
}

- (void)drawRect:(CGRect)rect {
    [self drawGrid:rect];
}

- (void)drawGrid:(CGRect)container {
    if (_patternGrid) {
        NSInteger row = _patternGrid.row;
        NSInteger column = _patternGrid.column;
        int w = (container.size.width - 2 * MMBThickness) / column;
        int h = (container.size.height - 2 * MMBThickness) / row;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, MMBThickness);
        float x = MMBThickness;
        float y = MMBThickness;
        MMBCell *cell = [[MMBCell alloc] initWithRow:0 column:0];
        for (int r = 0; r < row; ++r) {
            x = MMBThickness;
            for (int c = 0; c < column; ++c) {
                cell.row = r;
                cell.column = c;
                [self drawSquare:CGRectMake(x, y, w, h) inContext:context atCell:cell];
                x += w;
            }
            y += h;
        }
    }
}

- (void)drawSquare:(CGRect)rect inContext:(CGContextRef) context atCell:(MMBCell *) cell{
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    [_borderColor setStroke];
    if (_patternShow) {
        if ([_patternGrid isMarkedAtRow:cell.row column:cell.column]) {
            [_patternSquareColor setFill];
        } else {
            [_emptySquareColor setFill];
        }
    } else {
        if ([_patternGrid isRemovedMarkAtRow:cell.row column:cell.column]) {
            [_patternSquareColor setFill];
        } else {
            [_emptySquareColor setFill];
        }
    }
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
    if ([_activeCell isEqualToCell:cell]) {
        if (_moveState == LOST) {
            [_crossImage drawInRect:rect];
        } else {
            [_checkImage drawInRect:rect];
        }
    }
}

- (MMBCell *)determineTouchCell:(CGPoint)point {
    NSInteger c = point.x / (self.frame.size.width / _patternGrid.column);
    NSInteger r = point.y / (self.frame.size.height / _patternGrid.row);
    return [[MMBCell alloc] initWithRow:r column:c];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    @synchronized (self) {
        if (_touchable) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self];
            MMBCell *cell = [self determineTouchCell:point];
            [self.delegate performSelector:@selector(patternView:makeMoveAtCell:) withObject:self withObject:cell];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // NSLog(@"touchesMoved");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // NSLog(@"touchesCancelled");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // NSLog(@"touchesEnded");
}

- (void)acceptTouchesAndClearBlock {
    @synchronized (self) {
        _touchable = YES;
        _patternShow = NO;
    }
    [self setNeedsDisplay];
}

- (void)displayPattern {
    @synchronized (self) {
        _patternShow = YES;
    }
}

- (void)rejectTouches {
    @synchronized (self) {
        _touchable = NO;
    }
}

- (void)setActiveCell:(MMBCell *)cell toState:(MoveState)state {
    _activeCell = cell;
    _moveState = state;
}

@end
