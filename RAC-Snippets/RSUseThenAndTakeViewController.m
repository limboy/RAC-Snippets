//
//  RSChainSignalsViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/11/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSUseThenAndTakeViewController.h"
#import "RSSnippetsDataSource.h"

@interface RSUseThenAndTakeViewController ()
@property (nonatomic) UIButton *button;
@property (nonatomic) UIViewController *presentedVC;
@end

@implementation RSUseThenAndTakeViewController

+ (void)load
{
    return [[RSSnippetsDataSource sharedInstance] addWithDescription:@"Use `then` and `take`" demoClass:[self class]];
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
    [self.view addSubview:self.button];
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self.navigationController presentViewController:self.presentedVC animated:YES completion:^{
                [subscriber sendCompleted];
            }];
            return nil;
        }] then:^RACSignal *{
            // until `viewDidAppear:` is triggered by system, then the signal is completed
            // if this signal is not complete, button's state keeps disable.
            return [[self rac_signalForSelector:@selector(viewDidAppear:)] take:1];
        }];
        
        return signal;
    }];
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
        _button.frame = CGRectMake(100, 100, 100, 30);
        [_button setTitle:@"Present a VC" forState:UIControlStateNormal];
    }
    return _button;
}

- (UIViewController *)presentedVC
{
    if (!_presentedVC) {
        _presentedVC = [[UIViewController alloc] init];
        _presentedVC.view.backgroundColor = [UIColor lightGrayColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(100, 100, 100, 30);
        [button setTitle:@"Back" forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [_presentedVC.view addSubview:button];
    }
    return _presentedVC;
}

@end
