//
//  Scene.m
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Scene.h"

#import "Mesh.h"
#import "Material.h"

#include "assimp.h"

#include "aiScene.h"
#include "aiPostProcess.h"

@interface Scene ()

@property (nonatomic, retain) NSArray *meshes;
@property (nonatomic, retain) NSArray *materials;

@end

@implementation Scene

@synthesize meshes;
@synthesize materials;

+ (id) sceneFromFile:(NSString *)file
{
    return [[[self alloc] initFromFile:file] autorelease];
}

- (id) initFromFile:(NSString *)file
{
    if (self = [super init])
    {
        const aiScene *scene = aiImportFile([file cStringUsingEncoding:NSUTF8StringEncoding], aiProcessPreset_TargetRealtime_Quality);
        if (![self loadScene:scene])
        {
            [self release];
            self = nil;
        }
        if (scene)
            aiReleaseImport(scene);
    }
    return self;
}

- (void) dealloc
{
    [self setMeshes:nil];
    [self setMaterials:nil];

    [super dealloc];
}

- (BOOL) loadScene:(const aiScene *)scene
{
    if (!scene)
        return NO;
    
    NSMutableArray* newMaterials = [NSMutableArray arrayWithCapacity:scene->mNumMaterials];
    for (int i = 0; i < scene->mNumMaterials; ++i)
    {
        [newMaterials addObject:[Material materialWithAsset:scene->mMaterials[i]]];
    }

    NSMutableArray* newMeshes = [NSMutableArray arrayWithCapacity:scene->mNumMeshes];
    for (int i = 0; i < scene->mNumMeshes; ++i)
    {
        aiMesh *sceneMesh = scene->mMeshes[i];
        Material *material = [newMaterials objectAtIndex:(sceneMesh->mMaterialIndex)];
        Mesh *mesh = [Mesh meshWithAsset:sceneMesh
                                material:material];
        [newMeshes addObject:mesh];
    }

    [self setMaterials:newMaterials];
    [self setMeshes:newMeshes];
    
    return YES;
}

- (void) render
{
    for (Mesh *mesh in [self meshes])
    {
        [mesh render];
    }
}

@end
