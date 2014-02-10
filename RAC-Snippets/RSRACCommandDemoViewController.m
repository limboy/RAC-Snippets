//
//  RSRACCommandDemoViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/10/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSRACCommandDemoViewController.h"
#import "RSSnippetsDataSource.h"

@interface RSRACCommandDemoViewController ()

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 30);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
