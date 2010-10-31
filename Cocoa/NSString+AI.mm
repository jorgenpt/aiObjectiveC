//
//  NSString+AI.m
//  aiObjectiveC
//
//  Created by Jørgen P. Tjernø on 10/31/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "NSString+AI.h"

#include "aiTypes.h"

@implementation NSString (ai)

+ (id) stringWithAIString:(aiString *)aString
{
    return [[[self alloc] initWithAIString:aString] autorelease];
}

- (id) initWithAIString:(aiString *)aString
{
    if (aString == NULL)
    {
        [self release];
        self = nil;
    }
    else
    {
        self = [self initWithBytes:aString->data
                            length:aString->length
                          encoding:NSUTF8StringEncoding];
    }

    return self;
}

@end
