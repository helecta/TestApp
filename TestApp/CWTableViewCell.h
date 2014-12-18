//
//  CWTableViewCell.h
//  TestApp
//
//  Created by Liliya Fedotova on 18.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cwTitle;
@property (weak, nonatomic) IBOutlet UILabel *cwText;

@end
