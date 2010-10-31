//
//  Mesh.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum BufferObjects {
    BUFFER_INDICES,
    BUFFER_VERTICES,
    BUFFER_COLORS,
    BUFFER_NORMALS,
    BUFFER_TEXTURE_COORDS,
    
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

- (void) render;

@end
