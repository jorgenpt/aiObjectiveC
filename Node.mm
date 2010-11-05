//
//  Node.mm
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/4/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Node.h"
#import "NSString+AI.h"
#import "Mesh.h"

#include "assimp.h"

@implementation Node

@synthesize name, meshes, children;

+ (id) nodeWithNode:(aiNode *)node
             meshes:(NSArray *)sceneMeshes
{
    return [[[self alloc] initWithNode:node
                                meshes:sceneMeshes] autorelease];
}

- (id) init
{
    if (self = [super init])
    {
        [self setName:@""];
        [self setMeshes:[NSMutableArray array]];
        [self setChildren:[NSMutableArray array]];
        aiIdentityMatrix4(&transformation);
    }
    
    return self;
}

- (id) initWithNode:(aiNode *)node
             meshes:(NSArray *)sceneMeshes
{
    if (self = [self init])
    {
        [self setName:[NSString stringWithAIString:&node->mName]];
        transformation = node->mTransformation;
        aiTransposeMatrix4(&transformation);

        for (int i = 0; i < node->mNumMeshes; ++i)
            [meshes addObject:[sceneMeshes objectAtIndex:node->mMeshes[i]]];

        for (int i = 0; i < node->mNumChildren; ++i)
            [children addObject:[Node nodeWithNode:node->mChildren[i]
                                            meshes:sceneMeshes]];
    }
    
    return self;
}

- (void) dealloc
{
    [self setName:nil];
    [self setMeshes:nil];
    [self setChildren:nil];

    [super dealloc];
}

- (void) render
{
    glPushMatrix();
    glMultMatrixf((GLfloat *)&transformation);
    for (Mesh *mesh in meshes)
        [mesh render];

    for (Node *node in children)
        [node render];
    glPopMatrix();
}

@end
