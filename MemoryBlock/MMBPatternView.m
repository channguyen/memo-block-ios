//
//  MMBPatternView.m
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import "MMBPatternView.h"
#import "MMBPatternGrid.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define HEX(c)       [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

static const float MMBThickness = 4.0f;

typedef struct {
    int r;
    int c;
} Cell;

@interface MMBPatternView() {
    UIColor *borderColor;
    UIColor *emptySquareColor;
    UIColor *patternSquareColor;
    UIColor *wrongSquareColor;
    Cell currentCell;
}
@end

@implementation MMBPatternView

- (id) initWithPatternGrid {
    _patternGrid = [[MMBPatternGrid alloc] initWithRow:4 column:4];
    self.showPattern = true;
    self.userInteractionEnabled = YES;
    
    // Private
    borderColor = HEX(0x31748f);
    emptySquareColor = HEX(0xe6e6fa);
    patternSquareColor = HEX(0xff3016);
    wrongSquareColor = HEX(0x000000);
    currentCell.r = 1;
    currentCell.c = 1;
    
    for (int r = 0; r < _patternGrid.row; ++r) {
        NSMutableString *s = [[NSMutableString alloc] initWithFormat:@""];
        for (int c = 0; c < _patternGrid.column; ++c) {
            [s appendString:[NSString stringWithFormat:@"|%d|", [_patternGrid isMarkedAtRow:r column:c]]];
        }
        NSLog(@"%@", s);
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self initWithPatternGrid];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self = [self initWithPatternGrid];
    }
    return self;
}

- (BOOL)shouldDrawCell:(Cell)cell {
    return cell.r != -1 && cell.c != -1;
}

- (void)drawRect:(CGRect)rect {
    [self drawGrid:rect];
}

- (void)drawGrid:(CGRect)container {
    NSInteger row = self.patternGrid.row;
    NSInteger column = self.patternGrid.column;
    int w = (container.size.width - 2 * MMBThickness) / column;
    int h = (container.size.height - 2 * MMBThickness) / row;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, MMBThickness);
    float x = MMBThickness;
    float y = MMBThickness;
    Cell cell;
    for (int r = 0; r < row; ++r) {
        x = MMBThickness;
        for (int c = 0; c < column; ++c) {
            cell.r = r;
            cell.c = c;
            [self drawSquare:CGRectMake(x, y, w, h) inContext:context atCell:cell];
            x += w;
        }
        y += h;
    }
    // CGContextRelease(context);
}

- (void)drawSquare:(CGRect)rect inContext:(CGContextRef) context atCell:(Cell) cell{
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    [borderColor setStroke];
    if (self.showPattern) {
        if ([self.patternGrid isMarkedAtRow:cell.r column:cell.c]) {
            [patternSquareColor setFill];
        } else {
            [emptySquareColor setFill];
        }
    } else {
        [emptySquareColor setFill];
    }
    if (cell.r == currentCell.r && cell.c == currentCell.c) {
        if ([self shouldDrawCell:currentCell]) {
            [wrongSquareColor setFill];
        }
    }
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}

- (Cell)determineTouchCell:(CGPoint)point {
    Cell cell;
    cell.c = point.x / (self.frame.size.width / self.patternGrid.column);
    cell.r = point.y / (self.frame.size.height / self.patternGrid.row);
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    Cell cell = [self determineTouchCell:point];
    BOOL correct = NO;
    if ([self.patternGrid isMarkedAtRow:cell.r column:cell.c]) {
        correct = YES;
    }
    [self.delegate performSelector:@selector(patternView:makeMove:) withObject:self withObject:[NSNumber numberWithBool:correct]];
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

@end
