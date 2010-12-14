//
//  Scene.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/29/10.
//  Copyright 2010 devSoft. All rights reserved.
//

@class Node;
struct aiScene;

@interface Scene : NSObject {
    NSArray *meshes;
    NSArray *materials;
    Node *rootNode;
    NSDictionary *animations;
}

@property (nonatomic, retain) NSDictionary *animations;

+ (id) sceneFromFile:(NSString *)file;
- (id) initFromFile:(NSString *)file;
- (void) dealloc;

- (BOOL) loadScene:(const aiScene *)scene;

- (void) render;

@end
