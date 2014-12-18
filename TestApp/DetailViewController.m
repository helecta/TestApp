//
//  DetailViewController.m
//  TestApp
//
//  Created by Liliya Fedotova on 16.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize titleText;

#pragma mark - Managing the detail item

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.titleText) {
        self.titleLabel.text = self.titleText;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
