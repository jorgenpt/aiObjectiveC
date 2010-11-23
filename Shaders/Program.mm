//
//  Program.m
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Program.h"

#import "Shader.h"
#import "GLErrorChecking.h"

#include "aiTypes.h"

#define NSARRAY_FROM_NIL_TERMINATED_ID_VA(list, array) \
do { \
    id object; \
    while (object = va_arg(list, id)) \
        [array addObject:object]; \
} while (0)\

@implementation Program

#pragma mark -
#pragma mark Object management

+ (id) programWithShaders:(Shader *) firstShader, ...
{
    NSMutableArray *args = [NSMutableArray array];
    if (firstShader)
    {
        [args addObject:firstShader];
        va_list shaders;
        va_start(shaders, firstShader);
        NSARRAY_FROM_NIL_TERMINATED_ID_VA(shaders, args);
        va_end(shaders);
    }

    return [[[self alloc] initWithShaderArray:args] autorelease];
}

- (id) init
{
    if (self = [super init])
    {
        glCheckAndClearErrors();
        programId = glCreateProgram();
        if (!programId)
        {
            glCheckAndClearErrors();
            NSLog(@"Could not create program!");
            [self release];
            self = nil;
        }
    }

    return self;
}

- (id) initWithShaders:(Shader *) firstShader, ...
{
    NSMutableArray *args = [NSMutableArray array];
    if (firstShader)
    {
        [args addObject:firstShader];
        va_list shaders;
        va_start(shaders, firstShader);
        NSARRAY_FROM_NIL_TERMINATED_ID_VA(shaders, args);
        va_end(shaders);
    }

    return [self initWithShaderArray:args];
}

- (id) initWithShaderArray:(NSArray *)shaders
{
    if (self = [self init])
    {
        for (Shader *shader in shaders)
        {
            if (self && ![self attachShader:shader])
            {
                NSLog(@"Could not attach shaders to program.");
                [self release];
                self = nil;
            }
        }

        if (self && ![self link])
        {
            NSLog(@"Could not link shader program.");
            [self release];
            self = nil;
        }
    }

    return self;
}

- (void) dealloc
{
    if (programId)
        glDeleteProgram(programId);

    [super dealloc];
}

#pragma mark -
#pragma mark Troubleshooting

- (BOOL) validate
{
    glCheckAndClearErrors();

    glValidateProgram(programId);
    if (glHasError())
    {
        NSLog(@"Couldn't validate program!");
        return NO;
    }

    GLint validateStatus;
    glGetProgramiv(programId, GL_VALIDATE_STATUS, &validateStatus);
    if (glHasError())
    {
        NSLog(@"Couldn't validate program: %@", [self log]);
        return NO;
    }

    return (validateStatus == GL_TRUE);
}

- (NSString *) log
{
    glCheckAndClearErrors();

    GLint length;
    glGetProgramiv(programId, GL_INFO_LOG_LENGTH, &length);
    if (glHasError())
        return nil;

    GLchar *logCstring = (GLchar *)malloc(length * sizeof(GLchar));
    glGetProgramInfoLog(programId, length * sizeof(GLchar), NULL, logCstring);
    if (glHasError())
    {
        free(logCstring);
        return nil;
    }

    NSString *log = [NSString stringWithCString:logCstring
                                       encoding:NSASCIIStringEncoding];
    free(logCstring);

    return log;
}

#pragma mark -
#pragma mark Building a program

- (BOOL) attachShaders:(NSArray *)shaders
{
    for (Shader *shader in shaders)
    {
        if (![self attachShader:shader])
            return NO;
    }

    return YES;
}

- (BOOL) attachShader:(Shader *)shader
{
    glCheckAndClearErrors();

    glAttachShader(programId, shader->shaderId);
    return !glHasError();
}

- (BOOL) detachShader:(Shader *)shader
{
    glCheckAndClearErrors();

    glDetachShader(programId, shader->shaderId);
    return !glHasError();
}

- (BOOL) link
{
    GLint linkStatus;
    glCheckAndClearErrors();

    glLinkProgram(programId);
    if (glHasError())
        return NO;

    glGetProgramiv(programId, GL_LINK_STATUS, &linkStatus);
    if (glHasError())
        return NO;

    if (!linkStatus)
    {
        NSLog(@"Linking failed: %@", [self log]);
        return NO;
    }

    GLint activeAttributes;
    glGetProgramiv(programId, GL_ACTIVE_ATTRIBUTES, &activeAttributes);
    for (int i = 0; i < activeAttributes; ++i)
    {
        char name[512];
        GLint size;
        GLenum type;
        glGetActiveAttrib(programId, i, 512, NULL, &size, &type, name);
        NSLog(@"%i = %s (%i components, type %i)", i, name, size, type);
    }

    return YES;
}

#pragma mark -
#pragma mark Using a program

- (void) bind
{
    glCheckAndClearErrorsIfDEBUG();

    glUseProgram(programId);

    glCheckAndClearErrorsIfDEBUG();
}

+ (void) unbind
{
    glCheckAndClearErrorsIfDEBUG();

    glUseProgram(0);

    glCheckAndClearErrorsIfDEBUG();
}

- (void) unbind
{
    [[self class] unbind];
}

- (void) setUniform:(NSString *)name
            toFloat:(float)value
{
    glCheckAndClearErrorsIfDEBUG();

    glUseProgram(programId);
    glUniform1f(glGetUniformLocation(programId, [name cStringUsingEncoding:NSASCIIStringEncoding]), value);

    glCheckAndClearErrorsIfDEBUG();
}

- (void) setUniform:(NSString *)name
              toInt:(int)value
{
    glCheckAndClearErrorsIfDEBUG();

    glUseProgram(programId);
    glUniform1i(glGetUniformLocation(programId, [name cStringUsingEncoding:NSASCIIStringEncoding]), value);

    glCheckAndClearErrorsIfDEBUG();
}

- (void) setUniform:(NSString *)name
           toFloats:(float *)values
   havingComponents:(int)components
          withCount:(int)count
{
    glCheckAndClearErrorsIfDEBUG();

    glUseProgram(programId);
    GLint location = glGetUniformLocation(programId, [name cStringUsingEncoding:NSASCIIStringEncoding]);
    switch (components)
    {
        case 1:
            glUniform1fv(location, count, values);
            break;
        case 2:
            glUniform2fv(location, count, values);
            break;
        case 3:
            glUniform3fv(location, count, values);
            break;
        case 4:
            glUniform4fv(location, count, values);
            break;
        default:
            NSLog(@"What!");
            break;
    }

    glCheckAndClearErrorsIfDEBUG();
}

- (void) setUniform:(NSString *)name
      to4x4Matrices:(aiMatrix4x4 *)values
           withCount:(int)count
{
    glCheckAndClearErrorsIfDEBUG();

    glUseProgram(programId);
    GLint location = glGetUniformLocation(programId, [name cStringUsingEncoding:NSASCIIStringEncoding]);

    // GL_TRUE means we transpose the matrices, because assimp uses column-major layout.
    glUniformMatrix4fv(location, count, GL_TRUE, (GLfloat *)values);

    glCheckAndClearErrorsIfDEBUG();
}

- (GLint) attributeLocation:(NSString *)name
{
    glCheckAndClearErrorsIfDEBUG();

    glUseProgram(programId);
    GLint location = glGetAttribLocation(programId, [name cStringUsingEncoding:NSASCIIStringEncoding]);

    glCheckAndClearErrorsIfDEBUG();
    return location;
}

@end
