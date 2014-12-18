//
//  CrazyWheelManager.h
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrazyWheelCommunicator.h"
#import "CWTextBuilder.h"

@protocol CrazyWheelManagerDelegate <NSObject>

//get list
- (void)didGetList:(NSArray *) list;
- (void)getListFailedWithError:(NSError *)error;

@end

@interface CrazyWheelManager : NSObject<CrazyWheelCommunicatorDelegate>

@property (strong, nonatomic) CrazyWheelCommunicator *communicator;
@property (weak, nonatomic) id<CrazyWheelManagerDelegate> delegate;

- (void)startGetList;

@end
