//
//  RSSnippetsDataSource.h
//  RAC-Snippets
//
//  Created by Limboy on 2/10/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSBaseDemoViewController;

@interface RSSnippetsDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, readonly) NSArray *snippets;

+ (instancetype)sharedInstance;

- (void)addWithDescription:(NSString *)description demoClass:(Class)demoClass;
@end
