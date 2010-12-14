//
//  Animation.h
//  RenderDemo
//
//  Created by Jørgen P. Tjernø on 12/13/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "aiAnim.h"

@interface Animation : NSObject {
    double duration;
    NSArray *channels;
}

@property (retain) NSArray *channels;

+ (id) animationWithAsset:(const aiAnimation *)asset;
- (id) initWithAsset:(const aiAnimation *)asset;
- (void) dealloc;

@end
