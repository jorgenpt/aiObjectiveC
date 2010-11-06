//
//  Shader.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

@interface Shader : NSObject {
@public
    GLuint shaderId;
}

+ (id) shaderOfType:(GLenum)shaderType
         fromString:(NSString *)shaderString;

- (id) initWithType:(GLenum)shaderType
         fromString:(NSString *)shaderString;
- (void) dealloc;

- (NSString *) source;
- (BOOL) setSource:(NSString *)shaderString;

- (NSString *) log;

@end
