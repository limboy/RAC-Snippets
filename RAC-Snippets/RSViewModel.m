//
//  RSViewModel.m
//  RAC-Snippets
//
//  Created by Limboy on 2/12/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSViewModel.h"
#import <AFNetworking.h>

@implementation RSViewModel

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (RACCommand *)fetchImageCommand
{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            [manager GET:@"http://lorempixel.com/g/400/200/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
        return signal;
    }];
    self.fetchedImage = [command.executionSignals switchToLatest];
    return command;
}
@end
