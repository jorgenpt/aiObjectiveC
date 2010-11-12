//
//  Mesh.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

enum BufferObjects {
    BUFFER_INDICES,
    BUFFER_VERTICES,
    BUFFER_COLORS,
    BUFFER_NORMALS,
    BUFFER_TEXTURE_COORDS,
    BUFFER_TANGENTS,
    BUFFER_BINORMALS,

    NUMBER_OF_BUFFERS
};

struct aiMesh;
@class Material;

@interface Mesh : NSObject {
    GLuint buffers[NUMBER_OF_BUFFERS];
    GLuint numTris;
    Material *material;
}

+ (id) meshWithAsset:(const aiMesh *)asset
            material:(Material *)theMaterial;
- (id) initWithAsset:(const aiMesh *)asset
            material:(Material *)theMaterial;
- (void) dealloc;

- (void) render;

@end
