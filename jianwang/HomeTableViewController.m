//
//  HomeTableViewController.m
//  jianwang
//
//  Created by admin on 16/10/13.
//  Copyright © 2016年 cj. All rights reserved.
//

#import "HomeTableViewController.h"
#import "clubTableViewCell.h"
#import "VoucherTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Advertisement.h"
#import "Club.h"
#import "Voucher.h"
@interface HomeTableViewController ()<CLLocationManagerDelegate>{
 
        CLLocation *location;
        NSInteger locVisit;
        NSInteger page;
        NSInteger perPage;
        NSInteger totalPage;
        BOOL loading;
}
    @property (strong, nonatomic) CLLocationManager *locationManager;
    @property (strong, nonatomic) UIActivityIndicatorView *aiv;
    @property (strong, nonatomic) NSTimer *timer;
    
    @property (strong, nonatomic) NSMutableArray *advertisments;
    @property (strong, nonatomic) NSMutableArray *clubs;


@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locationConfiguration];
    [self uiLayout];
    [self initializeData];
 //   [self userdaful];
   }
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tableView endEditing:YES];
}
//- (BOOL)loginCheck {
//    if ([[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"] isKindOfClass:[NSNull class]] || [[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"] == nil) {
//        return NO;
//    } else {
//        return YES;
//    }
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




- (void)locationConfiguration {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)getUserLocation {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager performSelector:@selector(requestWhenInUseAuthorization)];
        }
#endif
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"error = %@", [error description]);
    if (error) {
        [self checkError:error];
    }
}

- (void)checkError:(NSError *)error {
    switch([error code]) {
        case kCLErrorNetwork:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
            break;
        case kCLErrorDenied:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
            break;
        case kCLErrorLocationUnknown:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
            break;
        default:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    location = newLocation;
    if (locVisit == 0) {
        [self searchReGeocodeWithCoordinate];
        locVisit ++;
    }
}

- (void)searchReGeocodeWithCoordinate {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [Utilities setUserDefaults:@"UserLatitude" content:[NSString stringWithFormat:@"%f", location.coordinate.latitude]];
        [Utilities setUserDefaults:@"UserLongitude" content:[NSString stringWithFormat:@"%f", location.coordinate.longitude]];
        
        CLGeocoder *revGeo = [[CLGeocoder alloc] init];
        [revGeo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
            if (!error && placemarks.count > 0) {
                NSDictionary *info = [[placemarks objectAtIndex:0] addressDictionary];
                NSLog(@"info = %@", info);
                NSString *cityStr = info[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                [Utilities setUserDefaults:@"UserCity" content:cityStr];
                [self networkRequest];
            } else {
                NSLog(@"error = %@", [error description]);
            }
        }];
        [_locationManager stopUpdatingLocation];
    });
}

- (void)uiLayout {
    [self createTableHeader];
    [self setupRefreshControl];
}

- (void)createTableHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, UI_SCREEN_W / 3)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIScrollView *adSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, UI_SCREEN_W / 3)];
    adSV.tag = 10002;
    adSV.backgroundColor = [UIColor clearColor];
    adSV.scrollEnabled = YES;
    adSV.pagingEnabled = YES;
    adSV.showsVerticalScrollIndicator = NO;
    adSV.showsHorizontalScrollIndicator = NO;
    adSV.delaysContentTouches = YES;
    adSV.autoresizingMask = UIViewAutoresizingNone;
    [headerView addSubview:adSV];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)setupRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tag = 10001;
    
    NSString *title = [NSString stringWithFormat:@"正在获取数据..."];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone), NSFontAttributeName : [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)endRefreshing {
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.tableView viewWithTag:10001];
    [refreshControl endRefreshing];
}

- (void)initializeData {
    loading = NO;
    page = 0;
    perPage = 0;
    totalPage = 0;
    _advertisments = [NSMutableArray new];
    _clubs = [NSMutableArray new];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _aiv = [Utilities getCoverOnView:window];
    [self refreshData];
}

- (void)refreshData {
    page = 1;
    perPage = 10;
    [self updateData];
}

- (void)updateData {
    if (!loading) {
        loading = YES;
        [self networkRequest];
    }
}

- (void)networkRequest {
    NSString *request = @"/homepage/choice";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"page" : @(page), @"perPage" : @(perPage)}];
    if (![[Utilities getUserDefaults:@"UserLatitude"] isKindOfClass:[NSNull class]] && ![[Utilities getUserDefaults:@"UserLongitude"] isKindOfClass:[NSNull class]] && [Utilities getUserDefaults:@"UserLatitude"] != nil && [Utilities getUserDefaults:@"UserLongitude"] != nil) {
        [parameters setObject:[Utilities getUserDefaults:@"UserLongitude"] forKey:@"jing"];
        [parameters setObject:[Utilities getUserDefaults:@"UserLatitude"] forKey:@"wei"];
    }
    if (![[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]] && [Utilities getUserDefaults:@"UserCity"] != nil) {
        [parameters setObject:[Utilities getUserDefaults:@"UserCity"] forKey:@"city"];
    } else {
        [parameters setObject:@"无锡" forKey:@"city"];
    }
    
    NSLog(@"request = %@", request);
    NSLog(@"parameters = %@", parameters);
    [RequestAPI getURL:request withParameters:parameters success:^(id responseObject) {
        loading = NO;
        [_aiv stopAnimating];
        [self endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSArray *adArr = responseObject[@"advertisement"];
            NSDictionary *result = responseObject[@"result"];
            NSArray *clubArr = result[@"models"];
            NSDictionary *pageInfo = result[@"pagingInfo"];
            
            if (page == 1) {
                [_advertisments removeAllObjects];
                for (NSDictionary *adDic in adArr) {
                    Advertisement *advertisment = [[Advertisement alloc] initWithDictionary:adDic];
                    [_advertisments addObject:advertisment];
                }
                [self tableHeaderLayout];
                [_clubs removeAllObjects];
            }
            
            for (NSDictionary *clubDic in clubArr) {
                Club *club = [[Club alloc] initWithDictionary:clubDic];
                [_clubs addObject:club];
            }
            
            [self.tableView reloadData];
            totalPage = [pageInfo[@"totalPage"] integerValue];
        } else {
            NSString *errorDesc = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorDesc andTitle:nil onView:self];
        }
    } failure:^(NSError *error) {
        loading = NO;
        [_aiv stopAnimating];
        [self endRefreshing];
        NSLog(@"error = %@", error.description);
        [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
    }];
}

- (void)tableHeaderLayout {
    UIScrollView *adSV = (UIScrollView *)[self.tableView.tableHeaderView viewWithTag:10002];
    if (_advertisments.count > 0) {
        [adSV setContentSize:CGSizeMake(adSV.frame.size.width * _advertisments.count, adSV.frame.size.height)];
        
        for (NSInteger i = 0; i < _advertisments.count; i ++) {
            UIImageView *defaultAdIV = [[UIImageView alloc] initWithFrame:CGRectMake(0 + adSV.frame.size.width * i, 0, adSV.frame.size.width, adSV.frame.size.height)];
            Advertisement *ad = _advertisments[i];
            NSURL *adUrl = [NSURL URLWithString:ad.imgUrl];
            [defaultAdIV sd_setImageWithURL:adUrl placeholderImage:[UIImage imageNamed:@"AdDefault"]];
            defaultAdIV.contentMode = UIViewContentModeScaleAspectFill;
            defaultAdIV.clipsToBounds = YES;
            [adSV addSubview:defaultAdIV];
        }
        
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollingAction) userInfo:nil repeats:YES];
    } else {
        [adSV setContentSize:CGSizeMake(adSV.frame.size.width, adSV.frame.size.height)];
        
        UIImageView *defaultAdIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, adSV.frame.size.width, adSV.frame.size.height)];
        defaultAdIV.image = [UIImage imageNamed:@"AdDefault"];
        defaultAdIV.contentMode = UIViewContentModeScaleAspectFill;
        defaultAdIV.clipsToBounds = YES;
        [adSV addSubview:defaultAdIV];
    }
}

- (void)scrollingAction {
    UIScrollView *adSV = (UIScrollView *) [self.tableView.tableHeaderView viewWithTag:10002];
    int nextPage = (int)(adSV.contentOffset.x / adSV.frame.size.width + 1);
    if (nextPage != _advertisments.count) {
        [adSV scrollRectToVisible:CGRectMake(nextPage * adSV.frame.size.width, 0, adSV.frame.size.width, adSV.frame.size.height) animated:YES];
    } else {
        [adSV scrollRectToVisible:CGRectMake(0, 0, adSV.frame.size.width, adSV.frame.size.height) animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _clubs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Club *club = _clubs[section];
    return club.vouchers.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Club *club = _clubs[indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubCell" forIndexPath:indexPath];
        
        NSURL *clubimgUrl = [NSURL URLWithString:club.imageUrl];
        
        
        return cell;
    } else {
        Voucher *voucher = club.vouchers[indexPath.row - 1];
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoucherCell" forIndexPath:indexPath];
        
        NSURL *voucherImgUrl = [NSURL URLWithString:voucher.imageUrl];
        [cell.voucherImage sd_setImageWithURL:voucherImgUrl placeholderImage:[UIImage imageNamed:@"Default"]];
        cell.vouchName.text = voucher.name;
        cell.voucherCate.text = voucher.category;
        cell.vouchPrice.text = [NSString stringWithFormat:@"%@元", voucher.price];
        cell.vouchSold.text = [NSString stringWithFormat:@"已售: %@", voucher.soldNo];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (UI_SCREEN_W - 20) / 16 * 9 + 20;
    } else {
        return (UI_SCREEN_W - 20) / 4 + 10;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _clubs.count - 1) {
        if (page < totalPage) {
            page ++;
            [self updateData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
    } else {
        [self performSegueWithIdentifier:@"Club2Voucher" sender:self.tableView];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Club2Voucher"]) {
        NSIndexPath *indexPath = [sender indexPathForSelectedRow];
        Club *club = _clubs[indexPath.section];
        Voucher *voucher = club.vouchers[indexPath.row - 1];
        
        UIPageViewController *voucherVC = segue.destinationViewController;
       // voucherVC.voucherId = voucher.voucherId;
    }
}
@end
