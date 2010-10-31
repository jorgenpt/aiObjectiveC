//
//  Mesh.m
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Mesh.h"

#import "Material.h"

#include "aiMesh.h"

@interface Mesh ()
@property (nonatomic, retain) Material *material;
@end

@implementation Mesh

@synthesize material;

+ (id) meshWithAsset:(const aiMesh *)asset
            material:(Material *)theMaterial
{
    return [[[self alloc] initWithAsset:asset
                               material:theMaterial] autorelease];
}

- (id) initWithAsset:(const aiMesh *)asset
            material:(Material *)theMaterial
{
    if (self = [super init])
    {
        [self setMaterial:theMaterial];

        // TODO: This is kinda unclean.
        assert(asset->mPrimitiveTypes == aiPrimitiveType_TRIANGLE);

        numTris = asset->mNumFaces;
        
        glGenBuffers(NUMBER_OF_BUFFERS, buffers);

        // Set up index buffer.
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffers[BUFFER_INDICES]);
        {
            unsigned int *indices = (unsigned int *)malloc(asset->mNumFaces * sizeof(unsigned int) * 3);
            int idx = 0;
            for (int i = 0; i < asset->mNumFaces; ++i)
            {
                aiFace &face = asset->mFaces[i];
                assert(face.mNumIndices == 3);
                for (int j = 0; j < face.mNumIndices; ++j)
                {
                    indices[idx++] = face.mIndices[j];
                }
            }
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, asset->mNumFaces * sizeof(unsigned int) * 3, indices, GL_STATIC_DRAW);
        }
        
        // Set up vertex buffer
        glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_VERTICES]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(aiVector3D) * asset->mNumVertices, asset->mVertices, GL_STATIC_DRAW);
        
        // Optionally set up color buffer.
        // TODO: Support more than 1 set of colors.
        if (asset->mColors[0])
        {
            glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_COLORS]);
            glBufferData(GL_ARRAY_BUFFER, sizeof(aiColor4D) * asset->mNumVertices, asset->mColors[0], GL_STATIC_DRAW);
        }
        else
        {
            glDeleteBuffers(1, &(buffers[BUFFER_COLORS]));
            buffers[BUFFER_COLORS] = 0;
        }

        // Optionally set up the normal buffer.
        if (asset->mNormals)
        {
            glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_NORMALS]);
            glBufferData(GL_ARRAY_BUFFER, sizeof(aiVector3D) * asset->mNumVertices, asset->mNormals, GL_STATIC_DRAW);
        }
        else
        {
            glDeleteBuffers(1, &(buffers[BUFFER_NORMALS]));
            buffers[BUFFER_NORMALS] = 0;
        }

        // Optionally set up the first texture coord buffer.
        // TODO: Support more than 1 set of texcoords.
        if (asset->mTextureCoords[0])
        {
            glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_TEXTURE_COORDS]);
            glBufferData(GL_ARRAY_BUFFER, sizeof(aiVector3D) * asset->mNumVertices, asset->mTextureCoords[0], GL_STATIC_DRAW);
        }
        else
        {
            glDeleteBuffers(1, &(buffers[BUFFER_TEXTURE_COORDS]));
            buffers[BUFFER_TEXTURE_COORDS] = 0;
        }
    }
    
    return self;
}

- (void) render
{
    glEnableClientState(GL_VERTEX_ARRAY);
    glBindBufferARB(GL_ARRAY_BUFFER_ARB, buffers[BUFFER_VERTICES]);
    glVertexPointer(3, GL_FLOAT, 0, 0);
    
    if (buffers[BUFFER_COLORS])
    {
        glEnableClientState(GL_COLOR_ARRAY);
        glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_COLORS]);
        glColorPointer(4, GL_FLOAT, 0, 0);
    }
    else
    {
        glDisableClientState(GL_COLOR_ARRAY);
    }
    
    if (buffers[BUFFER_NORMALS])
    {
        glEnableClientState(GL_NORMAL_ARRAY);
        glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_NORMALS]);
        glNormalPointer(GL_FLOAT, 0, 0);
    }
    else
    {
        glDisableClientState(GL_NORMAL_ARRAY);
    }

    if (buffers[BUFFER_TEXTURE_COORDS])
    {
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_TEXTURE_COORDS]);
        glTexCoordPointer(3, GL_FLOAT, 0, 0);
    }
    else
    {
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    }

    glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER_ARB, buffers[BUFFER_INDICES]);
    glDrawElements(GL_TRIANGLES, numTris * 3, GL_UNSIGNED_INT, 0);

    glBindBufferARB(GL_ARRAY_BUFFER_ARB, 0);
    glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER_ARB, 0);
}

@end
