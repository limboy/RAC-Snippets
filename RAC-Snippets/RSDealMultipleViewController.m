//
//  RSDealMultipleViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/12/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSDealMultipleViewController.h"
#import "RSSnippetsDataSource.h"

@interface RSDealMultipleViewController ()

@end

@implementation RSDealMultipleViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"Deal Multiple Errors" demoClass:[self class]];
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
    
    RACSubject *errors = [RACSubject subject];
    
    RACSignal *networkErrorSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // simulate network error
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [errors sendNext:[NSError errorWithDomain:@"networkError" code:108 userInfo:nil]];
        });
        return nil;
    }];
    
    RACSignal *loginErrorSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // simulate login error
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [errors sendNext:[NSError errorWithDomain:@"loginError" code:109 userInfo:nil]];
        });
        return nil;
    }];
    
    // manually make the signals hot
    [[RACSignal merge:@[networkErrorSignal, loginErrorSignal]] subscribeNext:^(id x) {}];
    
    [errors subscribeNext:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
