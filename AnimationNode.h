//
//  AnimationNode.h
//  RenderDemo
//
//  Created by Jørgen P. Tjernø on 12/13/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "aiAnim.h"

@interface AnimationNode : NSObject {
    aiNodeAnim data;
}

- (id) initWithNode:(const aiNodeAnim *)asset;
- (void) dealloc;

@end
