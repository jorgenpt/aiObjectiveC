//
//  Material.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/30/10.
//  Copyright 2010 devSoft. All rights reserved.
//

@class Program;

#include "aiMaterial.h"

@interface Material : NSObject {
    GLuint texture, bumpmap;
    Program *shader;
}

@property (nonatomic, retain) Program *shader;

+ (id) materialWithAsset:(const aiMaterial *)asset;
- (id) initWithAsset:(const aiMaterial *)asset;
- (void) dealloc;

- (BOOL) loadTexture:(NSString *)path;
- (GLuint) texture:(int)num
            ofType:(aiTextureType)type
         fromAsset:(const aiMaterial *)asset;

- (void) apply;

@end
