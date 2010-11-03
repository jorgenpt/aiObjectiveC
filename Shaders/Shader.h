//
//  Shader.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

@interface Shader : NSObject {
    GLuint shaderId;
    GLenum shaderType;
}

+ (id) shaderOfType:(GLenum)theShaderType
         fromString:(NSString *)shaderString;

- (id) initWithType:(GLenum)theShaderType
         fromString:(NSString *)shaderString;
- (void) dealloc;

- (NSString *) source;
- (BOOL) setSource:(NSString *)shaderString;

- (NSString *) log;

- (BOOL) attachToProgram:(GLuint)programId;
- (BOOL) detachFromProgram:(GLuint)programId;

@end
