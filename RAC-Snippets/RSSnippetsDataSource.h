//
//  RSSnippetsDataSource.h
//  RAC-Snippets
//
//  Created by Limboy on 2/10/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSnippetsDataSource : NSObject

@property (nonatomic, readonly) NSArray *snippets;

+ (instancetype)sharedInstance;

- (void)addWithDescription:(NSString *)description class:(Class)class;
@end
