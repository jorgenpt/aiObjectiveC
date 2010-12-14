//
//  ShaderManager.mm
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 11/2/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "ShaderManager.h"

#import "Program.h"
#import "Shader.h"
#import "Material.h"
#import "Mesh.h"

static ShaderManager *defaultInstance = nil;

@interface ShaderManager ()
@property (nonatomic, retain) NSMutableDictionary *vertexShaders, *fragmentShaders;
@end

@implementation ShaderManager

@synthesize vertexShaders, fragmentShaders;

+ (id) defaultShaderManager
{
    // This is duplicated inside the synchronized block to prevent a race condition.
    if (!defaultInstance)
    {
        @synchronized (self)
        {
            // We duplicate the condition here, because there could be a race condition.
            // The common case is checked outside the synchronized block, so that most accesses
            // won't require the lock. (If defaultInstance is set, it won't ever be unset)
            if (!defaultInstance)
            {
                defaultInstance = [[self alloc] init];
            }
        }
    }

    return defaultInstance;
}

- (id) init
{
    if (self = [super init])
    {
        [self setVertexShaders:[NSMutableDictionary dictionary]];
        [self setFragmentShaders:[NSMutableDictionary dictionary]];
    }

    return self;
}

- (void) dealloc
{
    [self setVertexShaders:nil];
    [self setFragmentShaders:nil];

    [super dealloc];
}

- (void) release
{
    if (self == defaultInstance)
        return;
    else
        [super release];
}

- (id) autorelease
{
    if (self == defaultInstance)
        return self;
    else
        return [super autorelease];
}

- (Shader *) shaderOfType:(GLenum)type
                 withName:(NSString *)name
             andExtension:(NSString *)extension
            fromDirectory:(NSString *)directory
{
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:name
                                                           ofType:extension
                                                      inDirectory:directory];
    if (!shaderPath)
    {
        NSLog(@"Attempted loading %@ shader that wasn't found: %@", extension, name);
        return nil;
    }

    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSASCIIStringEncoding
                                                          error:&error];
    if (!shaderString)
    {
        NSLog(@"Attempted loading %@ shader %@ from file %@, but failed: %@", extension, name, shaderPath, [error localizedDescription]);
        return nil;
    }

    return [Shader shaderOfType:type
                    fromString:shaderString];
}

- (Shader *) vertexShader:(NSString *)name
{
    Shader *shader = [[self vertexShaders] objectForKey:name];
    if (shader)
        return [[shader retain] autorelease];

    shader = [self shaderOfType:GL_VERTEX_SHADER
                       withName:name
                   andExtension:@"vert"
                  fromDirectory:@"Shaders/Vertex"];

    if (shader)
        [[self vertexShaders] setObject:shader
                                 forKey:name];
    else
            NSLog(@"Could not build vert shader %@", name);

    return shader;
}

- (Shader *) fragmentShader:(NSString *)name;
{

    Shader *shader = [[self fragmentShaders] objectForKey:name];
    if (shader)
        return [[shader retain] autorelease];

    shader = [self shaderOfType:GL_FRAGMENT_SHADER
                       withName:name
                   andExtension:@"frag"
                  fromDirectory:@"Shaders/Fragment"];

    if (shader)
        [[self fragmentShaders] setObject:shader
                                   forKey:name];
    else
        NSLog(@"Could not build frag shader %@", name);

    return shader;
}

- (Program *) shaderForMesh:(Mesh *)mesh
                   material:(Material *)material
{
    return nil;
}

@end
