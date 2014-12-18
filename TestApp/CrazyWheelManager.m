//
//  CrazyWheelManager.m
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import "CrazyWheelManager.h"

@implementation CrazyWheelManager

- (void)startGetList
{
    [self.communicator getList];
}

#pragma mark - CrazyWheelCommunicator
//get list
- (void)receivedGetListJSONAnswer:(NSArray *)objectNotation
{
    NSError *error = nil;
    NSArray *list = [CWTextBuilder listFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate getListFailedWithError:error];        
    } else {
        [self.delegate didGetList:list];
    }
}
- (void)getListFailedWithError:(NSError *)error
{
    [ self.delegate getListFailedWithError:error];
}
@end
