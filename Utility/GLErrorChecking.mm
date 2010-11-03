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

void _glClearErrors(const char *function, int line)
{
    GLenum error;    
    while (error = glGetError())
    {
        NSLog(@"%s, line %d: Warning, OpenGL error from previous code: %s", gluErrorString(error));
    }
}

BOOL _glHasError(const char *function, int line)
{
    GLenum error;
    BOOL errors = NO;

    while (error = glGetError())
    {
        errors = YES;
        NSLog(@"%s, line %d: Error, OpenGL error: %s", gluErrorString(error));
    }

    return errors;
}