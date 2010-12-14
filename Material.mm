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

@implementation Material

@synthesize texture, bumpmap;

+ (id) materialWithAsset:(const aiMaterial *)asset
{
    return [[[self alloc] initWithAsset:asset] autorelease];
}

- (id) initWithAsset:(const aiMaterial *)asset
{
    if (self = [super init])
    {
        bumpmap = texture = 0;
        glCheckAndClearErrors();

        if (asset->GetTextureCount(aiTextureType_DIFFUSE) > 0)
        {
            texture = [self texture:0
                             ofType:aiTextureType_DIFFUSE
                          fromAsset:asset];
        }

        if (asset->GetTextureCount(aiTextureType_HEIGHT) > 0)
        {
            bumpmap = [self texture:0
                             ofType:aiTextureType_HEIGHT
                          fromAsset:asset];
        }
    }

    return self;
}

- (void) dealloc
{
    if (texture)
        glDeleteTextures(1, &texture);
    if (bumpmap)
        glDeleteTextures(1, &bumpmap);

    [super dealloc];
}

- (GLuint) texture:(int)num
            ofType:(aiTextureType)type
         fromAsset:(const aiMaterial *)asset
{
    aiTextureMapMode mapMode;
    aiString *texturePathTmp = new aiString();
    asset->GetTexture(type, num, texturePathTmp, NULL, NULL, NULL, NULL, &mapMode);

    NSString *texturePath = [NSString stringWithAIString:texturePathTmp];
    delete texturePathTmp;

    GLuint textureId;
    glGenTextures(1, &textureId);
    glBindTexture(GL_TEXTURE_2D, textureId);
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
        glDeleteTextures(1, &textureId);
        textureId = 0;
    }

    return textureId;
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
    glCheckAndClearErrorsIfDEBUG();

    if (texture || bumpmap)
    {
        glEnable(GL_TEXTURE_2D);
    }
    else
    {
        glDisable(GL_TEXTURE_2D);
    }

    glCheckAndClearErrorsIfDEBUG();

    if (texture)
    {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture);
    }

    glCheckAndClearErrorsIfDEBUG();

    if (bumpmap)
    {
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, bumpmap);
    }

    glCheckAndClearErrorsIfDEBUG();
}

@end
