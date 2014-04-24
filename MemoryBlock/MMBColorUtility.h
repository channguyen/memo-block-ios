//
//  MMBColorUtility.h
//  MemoryBlock
//
//  Created by chan on 4/23/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#ifndef MemoryBlock_MMBColorUtility_h
#define MemoryBlock_MMBColorUtility_h

#define UICOLOR_RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UICOLOR_HEX(c)       [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

#endif
