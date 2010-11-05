//
//  Node.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/4/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#include "aiTypes.h"
#include "aiScene.h"

@interface Node : NSObject {
    NSString *name;
    NSMutableArray *meshes, *children;
    aiMatrix4x4 transformation;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *meshes, *children;

+ (id) nodeWithNode:(aiNode *)node
             meshes:(NSArray *)sceneMeshes;
- (id) init;
- (id) initWithNode:(aiNode *)node
             meshes:(NSArray *)sceneMeshes;
- (void) dealloc;

- (void) render;

@end
