//
//  HighScore.h
//  MemoryBlock
//
//  Created by chan on 4/20/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HighScore : NSManagedObject

@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSString *date;

@end
