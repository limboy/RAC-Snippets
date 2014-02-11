//
//  RSRACAndRACObserveAndMapViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/11/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSRACObserveAndFlattenMapViewController.h"
#import "RSSnippetsDataSource.h"
#import <AFNetworking.h>
#import <ReactiveCocoa.h>

@interface RSRACObserveAndFlattenMapViewController ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *statusLabel;
@property (nonatomic) NSString *imageURL;
@end

@implementation RSRACObserveAndFlattenMapViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"RACObserve And flattenMap" demoClass:[self class]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.statusLabel];
    
    // simulate fetching JSON from web
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (arc4random() % 2 == 0) {
            self.imageURL = @"http://img.hb.aicdn.com/413030d79874670798e3db10b2c82d1087e00a145ebc-nXmoed_sq140";
        } else {
            self.imageURL = @"http://nonexist.com/error";
        }
    });
    
    RACSignal *imageSignal = [[[RACObserve(self, imageURL) ignore:nil] flattenMap:^RACStream *(NSString *imageURL) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            [manager GET:imageURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }] replayLazily];
    
    // there should be more RAC way to do this
    self.statusLabel.text = @"Fetching Image...";
    [imageSignal subscribeNext:^(UIImage *image) {
        self.statusLabel.text = @"Image Fetched";
        self.imageView.image = image;
    } error:^(NSError *error) {
        self.statusLabel.text = @"Fetch Image Failed :(";
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    }
    return _imageView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320, 30)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor grayColor];
    }
    return _statusLabel;
}

@end
