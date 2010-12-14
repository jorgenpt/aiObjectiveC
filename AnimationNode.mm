//
//  AnimationNode.mm
//  RenderDemo
//
//  Created by Jørgen P. Tjernø on 12/13/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "AnimationNode.h"


@implementation AnimationNode

- (id) initWithNode:(const aiNodeAnim *)asset
{
    if (self = [super init])
    {
        data.mNumPositionKeys = asset->mNumPositionKeys;
        data.mPositionKeys = (aiVectorKey *)malloc(data.mNumPositionKeys * sizeof(aiVectorKey));
        memcpy(data.mPositionKeys, asset->mPositionKeys, data.mNumPositionKeys * sizeof(aiVectorKey));
        
        data.mNumRotationKeys = asset->mNumRotationKeys;
        data.mRotationKeys = (aiQuatKey *)malloc(data.mNumRotationKeys * sizeof(aiQuatKey));
        memcpy(data.mRotationKeys, asset->mRotationKeys, data.mNumRotationKeys * sizeof(aiQuatKey));

        data.mNumScalingKeys = asset->mNumScalingKeys;
        data.mScalingKeys = (aiVectorKey *)malloc(data.mNumScalingKeys * sizeof(aiVectorKey));
        memcpy(data.mScalingKeys, asset->mScalingKeys, data.mNumScalingKeys * sizeof(aiVectorKey));
    }
    
    return self;
}

- (void) dealloc
{
    free(data.mPositionKeys);
    free(data.mRotationKeys);
    free(data.mScalingKeys);

    [super dealloc];
}

@end
