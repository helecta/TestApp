//
//  DetailViewController.h
//  TestApp
//
//  Created by Liliya Fedotova on 16.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrazyWheelConstants.h"
#import "CWText.h"

@interface DetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (copy, nonatomic) NSString *titleText;
@property (strong, nonatomic) CWText *currentText;

@end

