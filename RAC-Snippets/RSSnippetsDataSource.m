//
//  RSSnippetsDataSource.m
//  RAC-Snippets
//
//  Created by Limboy on 2/10/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSSnippetsDataSource.h"

@interface RSSnippetsDataSource ()
@property (nonatomic) NSMutableArray *mutableSnippets;
@end

@implementation RSSnippetsDataSource

+ (instancetype)sharedInstance
{
    static RSSnippetsDataSource *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)addWithDescription:(NSString *)description demoClass:(Class)demoClass
{
    NSDictionary *snippet = NSDictionaryOfVariableBindings(description, demoClass);
    [self.mutableSnippets addObject:snippet];
}

- (NSArray *)snippets
{
    return [self.mutableSnippets copy];
}

#pragma mark - Accessors

- (NSMutableArray *)mutableSnippets
{
    if (!_mutableSnippets) {
        _mutableSnippets = [[NSMutableArray alloc] init];
    }
    return _mutableSnippets;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.snippets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.snippets[indexPath.row][@"description"];
    return cell;
}

@end
