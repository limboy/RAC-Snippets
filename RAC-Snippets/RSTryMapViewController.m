//
//  RSTryMapViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/11/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSTryMapViewController.h"
#import "RSSnippetsDataSource.h"

@interface RSTryMapViewController ()

@end

@implementation RSTryMapViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"use `tryMap`" demoClass:[self class]];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 30)];
    label.text = @"watch console";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"the"];
        [subscriber sendNext:@"quick"];
        [subscriber sendNext:@"brown"];
        [subscriber sendNext:@"fox"];
        [subscriber sendNext:@"jump"];
        [subscriber sendNext:@"over"];
        [subscriber sendNext:@"the"];
        [subscriber sendNext:@"lazy"];
        [subscriber sendNext:@"dog"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // tryMap can sendError if u set errorPtr and return nil
    // so in console, u won't c 'dog'.
    RACSignal *newSignal = [signal tryMap:^id(id value, NSError **errorPtr) {
        if ([value isEqualToString:@"lazy"]) {
            NSError *error = [NSError errorWithDomain:@"oops" code:108 userInfo:nil];
            *errorPtr = error;
        } else {
            return [NSString stringWithFormat:@"got %@", value];
        }
        return nil;
    }];
    
    [newSignal subscribeNext:^(id x) {
        NSLog(@"x:%@", x);
    } error:^(NSError *error) {
        NSLog(@"error:%@", error);
    } completed:^{
        // since newSignal is terminated when sending 'lazy', so this will not be triggered
        NSLog(@"completed");
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
