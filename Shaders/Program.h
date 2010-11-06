//
//  Program.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

@class Shader;

@interface Program : NSObject {
    GLuint programId;
}

#pragma mark -
#pragma mark Object management
+ (id) programWithVertex:(Shader *)vFrag
                fragment:(Shader *)fFrag;
- (id) init;
- (id) initWithVertex:(Shader *)vFrag
             fragment:(Shader *)fFrag;
- (void) dealloc;

#pragma mark -
#pragma mark Troubleshooting
- (BOOL) validate;
- (NSString *) log;

#pragma mark -
#pragma mark Building a program
- (BOOL) attachShader:(Shader *)shader;
- (BOOL) detachShader:(Shader *)shader;
- (BOOL) link;

#pragma mark -
#pragma mark Using a program
- (void) bind;
+ (void) unbind;
- (void) unbind;

@end
