//
//  Material.mm
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/30/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Material.h"

#import "NSString+AI.h"
#import "GLErrorChecking.h"

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
        glCheckAndClearErrors();

        if (asset->GetTextureCount(aiTextureType_DIFFUSE) > 0)
        {
            aiTextureMapMode mapMode;
            // TODO: Support other kinds of textures and various kinds of multitexturing (logical operations)
            aiString *texturePathTmp = new aiString();
            asset->GetTexture (aiTextureType_DIFFUSE, 0, texturePathTmp, NULL, NULL, NULL, NULL, &mapMode);
            NSString *texturePath = [NSString stringWithAIString:texturePathTmp];

            glGenTextures(1, &texture);
            glBindTexture(GL_TEXTURE_2D, texture);
            if (!glHasError() && [self loadTexture:texturePath])
            {
                if (mapMode == aiTextureMapMode_Wrap)
                {
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
                }
                else if (mapMode == aiTextureMapMode_Clamp)
                {
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
                }
                else
                {
                    NSLog(@"Unsupported texturemapmode for %@: %i", texturePath, mapMode);
                }

            }
            else
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

- (BOOL) loadTexture:(NSString *)path
{
    glCheckAndClearErrors();

    NSString *filename = [path lastPathComponent];
    NSString *texturePath = [[NSBundle mainBundle] pathForResource:filename
                                                            ofType:@""
                                                       inDirectory:@"Textures"];

    NSImage *image = [[NSImage alloc] initWithContentsOfFile:texturePath];
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

    GLenum format = hasAlpha ? GL_RGBA : GL_RGB;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glCheckAndClearErrors();

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, bytesPerRow / (bitsPerPixel >> 3));
    glCheckAndClearErrors();

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, imageRect.size.width,
                 imageRect.size.height, 0, format, GL_UNSIGNED_BYTE,
                 [imageRep bitmapData]);
    [imageRep release];
    if (glHasError())
    {
        return NO;
    }

    glGenerateMipmap(GL_TEXTURE_2D);
    glCheckAndClearErrors();

    return YES;
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

@end
