//
//  RSReloadDataViewController.m
//  RAC-Snippets
//
//  Created by Limboy on 2/11/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSReloadDataViewController.h"
#import "RSSnippetsDataSource.h"

@interface RSReloadDataViewController ()
@property (nonatomic) NSArray *data;
@end

@implementation RSReloadDataViewController

+ (void)load
{
    [[RSSnippetsDataSource sharedInstance] addWithDescription:@"UITableView reloadData" demoClass:[self class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = @[@"Pull Down to Refresh"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // setup refreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        NSInteger cellCount = arc4random() % 30;
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:cellCount];
        for (int i = 0; i < cellCount; i++) {
            NSInteger random = arc4random() % 1000;
            [data addObject:[NSString stringWithFormat:@"Random Number: %d", random]];
        }
        self.data = data;
        [self.refreshControl endRefreshing];
    }];
    self.refreshControl = refreshControl;
    
    // in some scenior, self.data is updated outside, so it is convenient to observe data change and reloadData
    [RACObserve(self, data) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

@end
