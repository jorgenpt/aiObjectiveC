//
//  Material.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/30/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct aiMaterial;

@interface Material : NSObject {
    GLuint texture;
}

+ (id) materialWithAsset:(const aiMaterial *)asset;
- (id) initWithAsset:(const aiMaterial *)asset;
- (void) dealloc;

- (void) apply;
- (BOOL) loadTexture:(NSString *)path;

@end
