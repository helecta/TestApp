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

@interface CrazyWheelViewController : UITableViewController<CrazyWheelManagerDelegate>
{
    CrazyWheelManager *_manager;
    NSArray *_list;
}
@property (strong, nonatomic) DetailViewController *detailViewController;


@end

