//
//  NSString+AI.h
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/31/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct aiString;

@interface NSString (ai)

+ (id) stringWithAIString:(aiString *)aString;
- (id) initWithAIString:(aiString *)aString;

@end
