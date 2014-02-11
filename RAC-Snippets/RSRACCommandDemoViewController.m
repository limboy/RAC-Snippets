//
//  RSRACCommandDemoViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/10/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSRACCommandDemoViewController.h"
#import "RSSnippetsDataSource.h"
#import <AFNetworking.h>

@interface RSRACCommandDemoViewController ()
@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *resultLabel;
@end

@implementation RSRACCommandDemoViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"RACCommand Demo" demoClass:[self class]];
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
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    [self.view addSubview:self.button];
    [self.view addSubview:self.resultLabel];
    
    RACSignal *flagSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // RACCommand initWithEnabeld default start with @YES, so here manually set to @NO
        [subscriber sendNext:@NO];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // now button is enabled
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    self.button.rac_command = [[RACCommand alloc] initWithEnabled:flagSignal signalBlock:^RACSignal *(id input) {
        // it's better to return a signal instead of execute block of code then return empty signal
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[AFHTTPRequestOperationManager manager] GET:@"http://httpbin.org/ip" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [subscriber sendNext:responseObject[@"origin"]];
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }];
    
    RACSignal *startSignal = [self.button.rac_command.executionSignals map:^id(id value) {
        return @"Sending Request...";
    }];
    
    RACSignal *successSignal = [self.button.rac_command.executionSignals switchToLatest];
    
    RACSignal *failSignal = [self.button.rac_command.errors map:^id(id value) {
        return @"Request Error";
    }];
    
    RAC(self, resultLabel.text) = [RACSignal merge:@[startSignal, successSignal, failSignal]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button setTitle:@"Get My IP" forState:UIControlStateNormal];
        _button.frame = CGRectMake(100, 100, 100, 30);
    }
    return _button;
}

- (UILabel *)resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
        _resultLabel.textColor = [UIColor darkGrayColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLabel;
}

@end
