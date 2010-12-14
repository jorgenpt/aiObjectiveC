//
//  Mesh.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#include "aiTypes.h"

#define MAX_NUMBER_OF_BONES 16

enum BufferObjects {
    BUFFER_INDICES,
    BUFFER_VERTICES,
    BUFFER_COLORS,
    BUFFER_NORMALS,
    BUFFER_TEXTURE_COORDS,
    BUFFER_TANGENTS,
    BUFFER_BINORMALS,

    BUFFER_BONEWEIGHTS,
    BUFFER_BONEWEIGHTS_LAST = BUFFER_BONEWEIGHTS + MAX_NUMBER_OF_BONES - 1,

    NUMBER_OF_BUFFERS
};

struct aiMesh;
@class Material, Program;

@interface Mesh : NSObject {
    aiMatrix4x4 boneOffsets[MAX_NUMBER_OF_BONES];

    GLuint buffers[NUMBER_OF_BUFFERS];
    GLuint numTris;
    Material *material;
    Program *shader;
}

@property (nonatomic, retain) Program *shader;

+ (id) meshWithAsset:(const aiMesh *)asset
            material:(Material *)theMaterial;
- (id) initWithAsset:(const aiMesh *)asset
            material:(Material *)theMaterial;
- (void) dealloc;

- (void) render;

@end
