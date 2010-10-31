//
//  Scene.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct aiScene;

@interface Scene : NSObject {
    NSArray *meshes;
    NSArray *materials;
}

+ (id) sceneFromFile:(NSString *)file;
- (id) initFromFile:(NSString *)file;
- (void) dealloc;

- (void) render;
- (BOOL) loadScene:(const aiScene *)scene;

@end
