//
//  CrazyWheelCommunicator.m
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import "CrazyWheelCommunicator.h"

@implementation CrazyWheelCommunicator

- (void)getList
{
    NSString *urlAsString = [NSString stringWithFormat:@"%@", DOMAIN_NAME];
    
    //NSLog(@"%@", urlAsString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlAsString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:0
                                                               error:nil];
        [self.delegate receivedGetListJSONAnswer:jsonArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate getListFailedWithError:error];
    }];
    
}

@end
