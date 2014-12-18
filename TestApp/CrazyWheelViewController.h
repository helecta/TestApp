//
//  MasterViewController.h
//  TestApp
//
//  Created by Liliya Fedotova on 16.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "CrazyWheelManager.h"
#import "CWTableViewCell.h"


@class DetailViewController;

@interface CrazyWheelViewController : UITableViewController<CrazyWheelManagerDelegate, UIAlertViewDelegate>
{
    CrazyWheelManager *_manager;
    NSArray *_list;
    NSTimer *_taskTimer;
}
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) Reachability *reachability;

@end

