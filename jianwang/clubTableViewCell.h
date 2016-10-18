//
//  clubTableViewCell.h
//  jianwang
//
//  Created by 巢思敏 on 16/10/18.
//  Copyright © 2016年 cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clubImage;
@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UILabel *clubAddress;
@property (weak, nonatomic) IBOutlet UILabel *clubDIst;

@end
