/*
 *  GLErrorChecking.h
 *  aiObjectiveC
 *
 *  Created by Jørgen P. Tjernø on 11/2/10.
 *  Copyright 2010 devSoft. All rights reserved.
 *
 */

#define glClearErrors() (_glClearErrors(__PRETTY_FUNCTION__, __LINE__))
#define glHasError()    (_glHasError(__PRETTY_FUNCTION__, __LINE__))

#if defined(__cplusplus)
#define GLEC_EXTERN extern "C"
#else
#define GLEC_EXTERN extern
#endif

GLEC_EXTERN void _glClearErrors(const char *function, int line);
GLEC_EXTERN BOOL _glHasError(const char *function, int line);