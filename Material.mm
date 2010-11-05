//
//  Material.mm
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/30/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Material.h"

#import "NSString+AI.h"

#include "aiMaterial.h"

@implementation Material

+ (id) materialWithAsset:(const aiMaterial *)asset
{
    return [[[self alloc] initWithAsset:asset] autorelease];
}

- (id) initWithAsset:(const aiMaterial *)asset
{
    if (self = [super init])
    {
        if (asset->GetTextureCount(aiTextureType_DIFFUSE) > 0)
        {
            // TODO: Support other kinds of textures and various kinds of multitexturing (logical operations)
            aiString *texturePathTmp = new aiString();
            asset->GetTexture (aiTextureType_DIFFUSE, 0, texturePathTmp, NULL, NULL, NULL, NULL, NULL);
            NSString *texturePath = [NSString stringWithAIString:texturePathTmp];
            delete texturePathTmp;

            glGenTextures(1, &texture);
            glBindTexture(GL_TEXTURE_2D, texture);
            if (![self loadTexture:texturePath])
            {
                NSLog(@"Failed loading texture '%@'!", texturePath);
                glDeleteTextures(1, &texture);
                texture = 0;
            }
        }
        else
        {
            texture = 0;
        }
    }

    return self;
}

- (void) dealloc
{
    if (texture)
        glDeleteTextures(1, &texture);

    [super dealloc];
}

- (void) apply
{
    if (texture)
    {
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, texture);
    }
    else
    {
        glDisable(GL_TEXTURE_2D);
    }
}

- (BOOL) loadTexture:(NSString *)path
{
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    if (!image)
    {
        return NO;
    }

    NSRect imageRect;
    imageRect.origin = NSZeroPoint;
    imageRect.size = [image size];

    [image lockFocus];
    [image setFlipped:YES];
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:imageRect];
    [image unlockFocus];
    [image release];

    if (!imageRep)
    {
        return NO;
    }

    int bytesPerRow = [imageRep bytesPerRow];
    int bitsPerPixel = [imageRep bitsPerPixel];
    BOOL hasAlpha = [imageRep hasAlpha];

    // TODO: Check glGetError.
    GLenum format = hasAlpha ? GL_RGBA : GL_RGB;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, bytesPerRow / (bitsPerPixel >> 3));

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, imageRect.size.width,
                 imageRect.size.height, 0, format, GL_UNSIGNED_BYTE,
                 [imageRep bitmapData]);
    [imageRep release];

    glGenerateMipmap(GL_TEXTURE_2D);

    return YES;
}

@end
