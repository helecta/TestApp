//
//  CWTextBuilder.h
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWText.h"

@interface CWTextBuilder : NSObject

+ (NSArray *)listFromJSON:(NSArray *)objectNotation error:(NSError **)error;

@end
