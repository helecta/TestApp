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
    
    _rightButton = self.navigationItem.rightBarButtonItem;
    _activityIndicatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReloadIcon"]];
    [self rotateLayerInfinite:_activityIndicatorImage.layer];
    if(_rightButtonInProgress == nil)
        _rightButtonInProgress = [[UIBarButtonItem alloc]initWithCustomView:_activityIndicatorImage];
    _rightButtonInProgress.enabled = NO;
    [self configNavBarTitle:NSLocalizedString(@"Crazy Wheels", @"title")];
    [self configNavBarBackItem];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    if([self.reachability currentReachabilityStatus] == NotReachable)
        [self showAlertViewInternetDown];
    else
    {
        [self startGetList];
        [self startTimedTask];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) startGetList
{
    self.navigationItem.rightBarButtonItem = nil;
    [self rotateLayerInfinite:_activityIndicatorImage.layer];
    self.navigationItem.rightBarButtonItem = _rightButtonInProgress;
    
    [_manager startGetList:_list];
}

#pragma mark - Events
- (IBAction)reloadList:(id)sender
{
    [self startGetList];
    NSLog(@"Mannual update Data");
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *destController = [segue destinationViewController];
        NSIndexPath * path = [self.tableView indexPathForCell:sender];
        [destController setCurrentText:[_list objectAtIndex:path.row]];
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
    if([_list count] != 0)
    {
        NSInteger oldListCount = [_list count];
        NSInteger newListCount = [newList count];
        
        if(newListCount < oldListCount)
        {
            NSMutableArray* rowsToRemove = [[NSMutableArray alloc] init];
            for(NSInteger i = 1; i <= (oldListCount - newListCount); i++)
                [rowsToRemove addObject:[NSIndexPath indexPathForRow:(oldListCount - i) inSection:0]];
            [self.tableView reloadRowsAtIndexPaths:rowsToRemove withRowAnimation:UITableViewRowAnimationRight];
            
            _list = newList;
            [self.tableView reloadData];
            
            NSMutableArray* rowsToUpdate = [[NSMutableArray alloc] init];
            for(NSInteger i = 0; i < newListCount; i++)
                [rowsToUpdate addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [self.tableView reloadRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            _list = newList;
            [self.tableView reloadData];
            NSMutableArray* rowsToAdd = [[NSMutableArray alloc] init];
            for(NSInteger i = 1; i <= (newListCount - oldListCount); i++)
                [rowsToAdd addObject:[NSIndexPath indexPathForRow:(newListCount - i) inSection:0]];
            
            NSMutableArray* rowsToUpdate = [[NSMutableArray alloc] init];
            for(NSInteger i = 0; i < oldListCount; i++)
                [rowsToUpdate addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            [self.tableView reloadRowsAtIndexPaths:rowsToAdd withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView reloadRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        _list = newList;
        [self.tableView reloadData];
    }
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        self.navigationItem.rightBarButtonItem = _rightButton;
    });
    
}
- (void)getListFailedWithError:(NSError *)error
{
    [self showAlertViewServerProblem];
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
    [self startGetList];
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
            [self showAlertViewInternetDown];
            [self stopTimedTask];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            [self startGetList];
            [self startTimedTask];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            [self startGetList];
            [self startTimedTask];
            break;
        }
    }
}

#pragma mark - AlertView
-(void) showAlertViewInternetDown
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                      message:NSLocalizedString(@"The internet is down.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                            otherButtonTitles: nil];
    [message show];
}
-(void) showAlertViewServerProblem
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                      message:NSLocalizedString(@"Problem with server", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                            otherButtonTitles: nil];
    [message show];
}
#pragma mark - Animations in view
- (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 0.9f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}

#pragma mark - UINav
-(void) configNavBarTitle:(NSString *)title
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor],NSForegroundColorAttributeName,
                                    [UIColor blackColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"HelveticaNeue" size:NAV_BAR_TITLE_FONT_SIZE], NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.topItem.title = title;
}
-(void)configNavBarBackItem
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}
@end
