//
//  CrazyWheelCommunicator.h
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrazyWheelConstants.h"
#import "AFHTTPRequestOperationManager.h"

@protocol CrazyWheelCommunicatorDelegate <NSObject>

//Get list
- (void)receivedGetListJSONAnswer:(NSArray *)objectNotation;
- (void)getListFailedWithError:(NSError *)error;

@end

@interface CrazyWheelCommunicator : NSObject

@property (weak, nonatomic) id<CrazyWheelCommunicatorDelegate> delegate;

- (void)getList;

@end
