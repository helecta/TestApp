//
//  DetailViewController.h
//  TestApp
//
//  Created by Liliya Fedotova on 16.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) NSString *titleText;

@end

