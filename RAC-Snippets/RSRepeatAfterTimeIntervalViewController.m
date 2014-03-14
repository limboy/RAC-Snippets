//
//  RSRepeatAfterTimeIntervalViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 3/14/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSRepeatAfterTimeIntervalViewController.h"
#import "RSSnippetsDataSource.h"
#import <ReactiveCocoa.h>

@interface RSRepeatAfterTimeIntervalViewController ()
@property (nonatomic) UILabel *statusLabel;
@end

@implementation RSRepeatAfterTimeIntervalViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"Repeat After TimeInterval" demoClass:[self class]];
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
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 30)];
    self.statusLabel.textColor = [UIColor darkGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.statusLabel];
    [self fetchResult];
}

- (void)fetchResult
{
    self.statusLabel.text = @"Fetching Result...";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://httpbin.org/delay/%d", arc4random() % 5 + 1]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLConnection rac_sendAsynchronousRequest:request] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        self.statusLabel.text = @"Result Fetched Auto Start After 3 Sec";
        [[[RACSignal interval:3 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
            [self fetchResult];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
