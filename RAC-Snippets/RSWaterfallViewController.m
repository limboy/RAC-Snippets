//
//  RSWaterfallViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/18/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSWaterfallViewController.h"
#import <CHTCollectionViewWaterfallLayout.h>
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <UIImageView+WebCache.h>
#import <SVPullToRefresh.h>
#import "RSSnippetsDataSource.h"

@interface RSWaterfallViewController () <CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSArray *pins;
@property (nonatomic) NSInteger loadMore;
@end

@implementation RSWaterfallViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"Waterfall" demoClass:[self class]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:layout]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    @weakify(self);
    [RACObserve(self, pins) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)] subscribeNext:^(RACTuple *arguments) {
        NSLog(@"collectionView:%@", arguments.first);
        NSLog(@"indexPath:%@", arguments.second);
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.loadMore++;
    }];
    
    // need to reset the cached values of respondsToSelector: of UIKit
    self.collectionView.delegate = self;
    
    RAC(self, pins) = [RACObserve(self, loadMore) flattenMap:^RACStream *(id value) {
        @strongify(self);
        NSString *url = @"http://api.huaban.com/users/10552351/pins?imit=20";
        if (self.pins.count) {
            url = [NSString stringWithFormat:@"%@&max=%d", url, [[self.pins lastObject][@"pin_id"] intValue]];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        return [[[[NSURLConnection rac_sendAsynchronousRequest:request]
                  deliverOn:[RACScheduler mainThreadScheduler]]
                 reduceEach:^id(NSURLResponse *response, NSData *data){
                     NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                     NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:self.pins];
                     [pins addObjectsFromArray:JSON[@"pins"]];
                     return pins;
                 }]
                catch:^RACSignal *(NSError *error) {
                    NSLog(@"error:%@", error);
                    return [RACSignal return:nil];
                }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pins.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDictionary *pin = self.pins[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw236", pin[@"file"][@"key"]]]];
    [cell.contentView addSubview:imageView];
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *pin = self.pins[indexPath.row];
    NSInteger height = [pin[@"file"][@"height"] intValue] * 140.f / [pin[@"file"][@"width"] intValue];
    return CGSizeMake(140, height);
}
@end
