//
//  ShaderManager.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

@class Shader;

@interface ShaderManager : NSObject {
    NSMutableDictionary *vertexShaders, *fragmentShaders;
}

+ (id) defaultShaderManager;

- (id) init;
- (void) dealloc;

- (void) release;
- (id) autorelease;

- (Shader *) vertexShader:(NSString *)name;
- (Shader *) fragmentShader:(NSString *)name;

@end
