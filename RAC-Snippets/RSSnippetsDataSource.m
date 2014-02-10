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

- (void)addWithDescription:(NSString *)description class:(Class)class
{
    NSDictionary *snippet = @{@"description": description, @"class": class};
    [self.mutableSnippets addObject:snippet];
}

- (NSArray *)snippets
{
    return [self.mutableSnippets copy];
}

@end
