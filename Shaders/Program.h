//
//  Program.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

@class Shader;

struct aiMatrix4x4;

@interface Program : NSObject {
    GLuint programId;
}

#pragma mark -
#pragma mark Object management
+ (id) programWithShaders:(Shader *)firstShader, ...;
- (id) init;
- (id) initWithShaders:(Shader *)firstShader, ...;
- (id) initWithShaderArray:(NSArray *)shaders;
- (void) dealloc;

#pragma mark -
#pragma mark Troubleshooting
- (BOOL) validate;
- (NSString *) log;

#pragma mark -
#pragma mark Building a program
- (BOOL) attachShaders:(NSArray *)shaders;
- (BOOL) attachShader:(Shader *)shader;
- (BOOL) detachShader:(Shader *)shader;
- (BOOL) link;

#pragma mark -
#pragma mark Using a program
- (void) bind;
+ (void) unbind;
- (void) unbind;

- (void) setUniform:(NSString *)name
          toFloat:(float)value;
- (void) setUniform:(NSString *)name
          toInt:(int)value;

- (void) setUniform:(NSString *)name
           toFloats:(float *)values
   havingComponents:(int)components
          withCount:(int)count;

- (void) setUniform:(NSString *)name
      to4x4Matrices:(aiMatrix4x4 *)values
          withCount:(int)count;

- (GLint) attributeLocation:(NSString *)name;

@end
