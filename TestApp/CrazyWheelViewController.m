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
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    if([self.reachability currentReachabilityStatus] == NotReachable)
        [self showAlertView];
    else
    {
        [_manager startGetList];
        [self startTimedTask];
    }
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
    if(![_list isEqualToArray:newList])
    {
        _list = newList;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
    
}
- (void)getListFailedWithError:(NSError *)error
{
    
}

#pragma mark - Timer
- (void)startTimedTask
{
    if(_taskTimer == nil)
        _taskTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:YES];
}
-(void)stopTimedTask
{
    if(_taskTimer != nil)
    {
        [_taskTimer invalidate];
        _taskTimer = nil;
    }
}
- (void)performBackgroundTask
{
    [_manager startGetList];
    NSLog(@"Update Data");
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
            [self showAlertView];
            [self stopTimedTask];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            [_manager startGetList];
            [self startTimedTask];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            [_manager startGetList];
            [self startTimedTask];
            break;
        }
    }
}

#pragma mark - AlertView
-(void) showAlertView
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                      message:NSLocalizedString(@"The internet is down.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                            otherButtonTitles: nil];
    [message show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    
//    if([title isEqualToString:@"Button 1"])
//    {
//        NSLog(@"Button 1 was selected.");
//    }  NSLog(@"Button 3 was selected.");
    
}
@end
