//
//  Mesh.mm
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Mesh.h"

#import "Material.h"
#import "Program.h"
#import "NSString+AI.h"
#import "GLErrorChecking.h"

#include "assimp.h"
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

        for (int i = 0; i < MAX_NUMBER_OF_BONES; ++i)
            aiIdentityMatrix4(&boneOffsets[i]);

        // Optionally set up bones!
        if (asset->HasBones())
        {
            for (int i = 0; i < asset->mNumBones; ++i)
            {
                aiBone *bone = asset->mBones[i];
                boneOffsets[i] = bone->mOffsetMatrix;
                float *weights = (float *)calloc(asset->mNumVertices, sizeof(float));
                for (int j = 0; j < bone->mNumWeights; ++j)
                {
                    aiVertexWeight &v = bone->mWeights[j];
                    weights[v.mVertexId] = v.mWeight;
                }

                glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_BONEWEIGHTS + i]);
                glBufferData(GL_ARRAY_BUFFER, sizeof(float) * asset->mNumVertices, weights, GL_STATIC_DRAW);
                free(weights);
            }
        }

        int numberOfUnusedBones = MAX_NUMBER_OF_BONES - asset->mNumBones;
        GLuint *firstUnusedBone = &(buffers[BUFFER_BONEWEIGHTS + asset->mNumBones]);
        glDeleteBuffers(numberOfUnusedBones, firstUnusedBone);
        memset(firstUnusedBone, 0, numberOfUnusedBones * sizeof(GLuint));

        // Optionally set up the bitangent & tangent buffer.
        if (asset->HasTangentsAndBitangents())
        {
            glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_BINORMALS]);
            glBufferData(GL_ARRAY_BUFFER, sizeof(aiVector3D) * asset->mNumVertices, asset->mBitangents, GL_STATIC_DRAW);
            glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_TANGENTS]);
            glBufferData(GL_ARRAY_BUFFER, sizeof(aiVector3D) * asset->mNumVertices, asset->mTangents, GL_STATIC_DRAW);
        }
        else
        {
            glDeleteBuffers(1, &(buffers[BUFFER_BINORMALS]));
            glDeleteBuffers(1, &(buffers[BUFFER_TANGENTS]));
            buffers[BUFFER_BINORMALS] = buffers[BUFFER_TANGENTS] = 0;
        }
    }

    return self;
}

- (void) dealloc
{
    [self setMaterial:nil];
    glDeleteBuffers(NUMBER_OF_BUFFERS, buffers);

    [super dealloc];
}

- (void) render
{
    glCheckAndClearErrorsIfDEBUG();

    [[self material] apply];

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

    if (buffers[BUFFER_TEXTURE_COORDS] || buffers[BUFFER_BINORMALS] || buffers[BUFFER_TANGENTS])
    {
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    else
    {
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    }

    if (buffers[BUFFER_TEXTURE_COORDS])
    {
        glClientActiveTexture(GL_TEXTURE0);
        glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_TEXTURE_COORDS]);
        glTexCoordPointer(3, GL_FLOAT, 0, 0);
    }

    if (buffers[BUFFER_TANGENTS])
    {
        glClientActiveTexture(GL_TEXTURE1);
        glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_TANGENTS]);
        glTexCoordPointer(3, GL_FLOAT, 0, 0);
    }

    if (buffers[BUFFER_BINORMALS])
    {
        glClientActiveTexture(GL_TEXTURE2);
        glBindBuffer(GL_ARRAY_BUFFER, buffers[BUFFER_BINORMALS]);
        glTexCoordPointer(3, GL_FLOAT, 0, 0);
    }

    Program *shader = [[self material] shader];
    for (int i = 0; i < MAX_NUMBER_OF_BONES; ++i)
    {
        NSString *attribute = [NSString stringWithFormat:@"boneweights%i", i];
        GLint location = [shader attributeLocation:attribute];
        glCheckAndClearErrorsIfDEBUG();

        if (location < 0)
            continue;

        GLuint buffer = buffers[BUFFER_BONEWEIGHTS + i];
        if (buffer)
        {
            glEnableVertexAttribArray(location);
            glBindBuffer(GL_ARRAY_BUFFER, buffer);
            glVertexAttribPointer(location, 1, GL_FLOAT, GL_FALSE, 0, 0);
        }
        else
        {
            glDisableVertexAttribArray(location);
        }

        glCheckAndClearErrorsIfDEBUG();
    }

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER_ARB, buffers[BUFFER_INDICES]);
    glDrawElements(GL_TRIANGLES, numTris * 3, GL_UNSIGNED_INT, 0);

    glBindBuffer(GL_ARRAY_BUFFER_ARB, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER_ARB, 0);
}

@end
