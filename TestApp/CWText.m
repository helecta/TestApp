//
//  CWText.m
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import "CWText.h"

@implementation CWText
@synthesize cwId, cwText, cwTitle;

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    if (!object || ![object isKindOfClass:[self class]])
        return NO;
    
    CWText * other = object;
    if (self.cwId != other.cwId)
        return YES;
    return YES;
}

@end
