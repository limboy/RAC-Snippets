//
//  RSNotificationViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/11/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSNotificationViewController.h"
#import "RSSnippetsDataSource.h"

@interface RSNotificationViewController ()
@property (nonatomic) UILabel *notificationLabel;
@end

@implementation RSNotificationViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"Notification with RAC" demoClass:[self class]];
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
    [self.view addSubview:self.notificationLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // if u want to get old value, u can use mapPreviousWithStart: combine:
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:nil object:nil] subscribeNext:^(NSNotification *notification) {
        self.notificationLabel.text = notification.name;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (UILabel *)notificationLabel
{
    if (!_notificationLabel) {
        _notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 30)];
        _notificationLabel.textColor = [UIColor grayColor];
        _notificationLabel.textAlignment = NSTextAlignmentCenter;
        _notificationLabel.font = [UIFont systemFontOfSize:14];
    }
    return _notificationLabel;
}

@end
