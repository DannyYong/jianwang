//
//  VoucherTableViewCell.h
//  jianwang
//
//  Created by 巢思敏 on 16/10/18.
//  Copyright © 2016年 cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *voucherImage;

@property (weak, nonatomic) IBOutlet UILabel *vouchName;
@property (weak, nonatomic) IBOutlet UILabel *voucherCate;
@property (weak, nonatomic) IBOutlet UILabel *vouchPrice;
@property (weak, nonatomic) IBOutlet UILabel *vouchSold;

@end
