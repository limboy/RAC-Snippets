//
//  RSSnippetsViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/10/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSSnippetsViewController.h"
#import "RSSnippetsDataSource.h"

@interface RSSnippetsViewController ()
@property (nonatomic) UITableView *tableView;
@end

@implementation RSSnippetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        self.tableView.dataSource = [RSSnippetsDataSource sharedInstance];
        self.tableView.delegate = self;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:self.tableView];
        self.title = @"RAC Snippets";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *snippet = [RSSnippetsDataSource sharedInstance].snippets[indexPath.row];
    UIViewController *viewController = [[snippet[@"demoClass"] alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
