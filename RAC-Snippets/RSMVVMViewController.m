//
//  RSMVVMViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/12/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSMVVMViewController.h"
#import "RSViewModel.h"
#import <AFNetworking.h>
#import "RSSnippetsDataSource.h"

@interface RSMVVMViewController ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIButton *button;
@property (nonatomic) RSViewModel *viewModel;
@end

@implementation RSMVVMViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"Simple MVVM" demoClass:[self class]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewModel = [[RSViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 100)];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.imageView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(0, 240, 320, 30);
    [self.button setTitle:@"Fetch Image" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    
    // to simply summerize MVVM:
    // viewController is treated as 'view', so data related operation should not appear here.
    // VC's main duty is to init views, init viewModels, then bind VM to Views
    // VC can respond to View's action like button tapped, pushViewController, etc.
    // VM primary do network / data related stuff, then provide signals for view to bind.
    self.button.rac_command = self.viewModel.fetchImageCommand;
    RAC(self, imageView.image) = self.viewModel.fetchedImage;
    
    [self.button.rac_command.errors subscribeNext:^(id x) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Fetch Image Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
