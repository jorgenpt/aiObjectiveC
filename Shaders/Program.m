//
//  Program.mm
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Program.h"

#import "Shader.h"
#import "GLErrorChecking.h"

@implementation Program

#pragma mark -
#pragma mark Object management

+ (id) programWithVertex:(Shader *)vFrag
                fragment:(Shader *)fFrag
{
    return [[[self alloc] initWithVertex:vFrag
                                fragment:fFrag] autorelease];
}

- (id) init
{
    if (self = [super init])
    {
        glCheckAndClearErrors();
        programId = glCreateProgram();
        if (!programId)
        {
            glHasError();
            [self release];
            self = nil;
        }
    }

    return self;
}
- (id) initWithVertex:(Shader *)vFrag
             fragment:(Shader *)fFrag
{
    if (self = [self init])
    {
        if (![self attachShader:vFrag] || ![self attachShader:vFrag])
        {
            NSLog(@"Could not attach shaders to program.");
            [self release];
            self = nil;
        }
        else if (![self link])
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

    return YES;
}

#pragma mark -
#pragma mark Using a program

- (void) bind
{
#ifdef DEBUG
    glCheckAndClearErrors();
#endif

    glUseProgram(programId);

#ifdef DEBUG
    glCheckAndClearErrors();
#endif
}
        
+ (void) unbind
{
#ifdef DEBUG
    glCheckAndClearErrors();
#endif
    
    glUseProgram(0);

#ifdef DEBUG
    glCheckAndClearErrors();
#endif    
}

- (void) unbind
{
    [[self class] unbind];
}

@end
