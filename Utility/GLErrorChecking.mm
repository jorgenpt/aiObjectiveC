/*
 *  GLErrorChecking.mm
 *  aiObjectiveC
 *
 *  Created by Jørgen P. Tjernø on 11/2/10.
 *  Copyright 2010 devSoft. All rights reserved.
 *
 */

#import "GLErrorChecking.h"

#import <OpenGL/glu.h>

void _glCheckAndClearErrors(const char *function, int line)
{
    GLenum error;    
    while ((error = glGetError()) != GL_NO_ERROR)
    {
        NSLog(@"%s, line %d: Error, OpenGL error: %s", function, line, gluErrorString(error));
    }
}

BOOL _glHasError(const char *function, int line)
{
    GLenum error;
    BOOL errors = NO;

    while ((error = glGetError()) != GL_NO_ERROR)
    {
        errors = YES;
        NSLog(@"%s, line %d: Error, OpenGL error: %s", function, line, gluErrorString(error));
    }

    return errors;
}