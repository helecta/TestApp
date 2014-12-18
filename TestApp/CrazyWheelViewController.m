//
//  MasterViewController.m
//  TestApp
//
//  Created by Liliya Fedotova on 16.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import "CrazyWheelViewController.h"
#import "DetailViewController.h"

@interface CrazyWheelViewController ()

@property NSMutableArray *objects;
@end

@implementation CrazyWheelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(_list == nil)
        _list = [[NSArray alloc] init];
    
    if(_manager == nil)
        _manager = [[CrazyWheelManager alloc] init];
    if(_manager.communicator == nil)
        _manager.communicator = [[CrazyWheelCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [_manager startGetList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *destController = [segue destinationViewController];
        //NSIndexPath * path = [self.tableView indexPathForCell:sender];
        [destController setTitleText:@"Text"];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellTableIdentifier = @"TestAppCell";
    
    CWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableIdentifier];
    }
    CWText *element = [_list objectAtIndex:indexPath.row];
    cell.cwTitle.text = element.cwTitle;
    cell.cwText.text = element.cwText;
    return cell;
}

#pragma mark - CrazyWheelManager
- (void)didGetList:(NSArray *) newList
{
    _list = newList;
    [self.tableView reloadData];
}
- (void)getListFailedWithError:(NSError *)error
{
    
}
#pragma mark - Internet cheker
-(void) reachabilityChanged:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [[notice object] currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            break;
        }
    }
}
@end
