//
//  Animation.mm
//  RenderDemo
//
//  Created by Jørgen P. Tjernø on 12/13/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Animation.h"
#import "AnimationNode.h"

@implementation Animation

@synthesize channels;

+ (id) animationWithAsset:(const aiAnimation *)asset
{
    return [[[self alloc] initWithAsset:asset] autorelease];
}

- (id) initWithAsset:(const aiAnimation *)asset
{
    if (self = [super init])
    {
        NSMutableArray *newChannels = [NSMutableArray arrayWithCapacity:asset->mNumChannels];
        for (int i = 0; i < asset->mNumChannels; ++i)
        {
            AnimationNode *node = [[AnimationNode alloc] initWithNode:asset->mChannels[i]];
            [newChannels addObject:[node autorelease]];
        }
        
        [self setChannels:newChannels];

        duration = asset->mDuration;
        if (asset->mTicksPerSecond > 0.0001)
            duration /= asset->mTicksPerSecond;
    }

    return self;
}

- (void) dealloc
{
    [self setChannels:nil];
    
    [super dealloc];
}

@end
