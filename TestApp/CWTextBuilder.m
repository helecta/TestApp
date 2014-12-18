//
//  CWTextBuilder.m
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import "CWTextBuilder.h"

@implementation CWTextBuilder

+ (NSArray *)listFromJSON:(NSArray *)objectNotation error:(NSError **)error oldList:(NSArray *)oldList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (NSDictionary *singleText in objectNotation) {
        CWText *newText = [[CWText alloc] init];
        for (NSString *key in singleText)
        {
            if([key isEqualToString:@"id"])
            {
                newText.cwId = [singleText valueForKey:key];
                if([oldList containsObject:newText] )
                    newText = [oldList objectAtIndex:[oldList indexOfObject:newText]];
            }
            else if([key isEqualToString:@"text"])
                newText.cwText = [singleText valueForKey:key];
            else if([key isEqualToString:@"title"])
                newText.cwTitle = [singleText valueForKey:key];
        }
        if(newText) [list addObject:newText];
    }
    return list;
}

@end
